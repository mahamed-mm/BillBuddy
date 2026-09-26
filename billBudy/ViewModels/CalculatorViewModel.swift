import SwiftUI

@Observable
final class CalculatorViewModel {
    // MARK: - Input Properties
    var billAmountText: String = ""
    var selectedPreset: TipPreset = .fifteen
    var customTipPercent: Double = 18.0
    var selectedCurrency: Currency = .nok
    var selectedRounding: RoundingMode = .none

    /// Equal shares, or an amount per person (`personSplits`). Not saved: every launch starts in
    /// `.equal` (Q4).
    var splitMode: SplitMode = .equal

    /// One row per person, Person 1 first. The rows exist in both modes, and Equal mode only hides
    /// them, so typed amounts last for the session (Q7). Not saved: every launch starts with every
    /// row empty (Q4).
    ///
    /// Views edit each row's `amountText`. Only `splitCount` adds or removes rows, always at the
    /// end, so the person numbers stay 1…`splitCount` in order, and the other rows keep their `id`
    /// and text.
    var personSplits: [PersonSplit] = [PersonSplit(personNumber: 1)]

    /// The head count, within `splitCountRange`. It's the number of rows, so the two always agree.
    ///
    /// Setting it clamps the value to 1…20, then appends empty (automatic) rows or removes rows
    /// from the end, typed or not (spec E5, E6, E8). It never rebuilds the array, so every row it
    /// keeps keeps its `id` (focus follows it) and its text.
    var splitCount: Int {
        get { personSplits.count }
        set {
            let count = min(max(newValue, Self.splitCountRange.lowerBound), Self.splitCountRange.upperBound)
            let current = personSplits.count
            if count < current {
                personSplits.removeLast(current - count)
            } else if count > current {
                personSplits += (current + 1...count).map { PersonSplit(personNumber: $0) }
            }
        }
    }

    /// The head counts the stepper allows: 1 to 20 people.
    static let splitCountRange = 1...20

    // MARK: - Persistence Bridge
    // Keys, defaults, and the store are set in `init(defaults:)`.
    @ObservationIgnored @AppStorage private var savedCurrency: String
    @ObservationIgnored @AppStorage private var savedTip: Int
    @ObservationIgnored @AppStorage private var savedSplit: Int
    @ObservationIgnored @AppStorage private var savedCustomTip: Double
    @ObservationIgnored @AppStorage private var savedRounding: Int

    // MARK: - Computed Properties
    // The bill, tip, and total are exact Int minor units of `selectedCurrency` (øre, cents). Each
    // `Double` amount derives from them through `Currency.amount(minorUnits:)`, for display.

    /// The bill in minor units, the one source of every result: 0 for text `AmountParser` rejects,
    /// including text above its cap. The text itself stays as typed.
    var billMinorUnits: Int { AmountParser.minorUnits(from: billAmountText, currency: selectedCurrency) ?? 0 }
    var billAmount: Double { selectedCurrency.amount(minorUnits: billMinorUnits) }
    var effectiveTipPercent: Double { selectedPreset == .custom ? customTipPercent : selectedPreset.percentage }

    /// 50 %, the top of the custom tip slider, in basis points.
    private static let maxTipBasisPoints = 5_000

    /// `effectiveTipPercent` in basis points (hundredths of a percent), to the nearest basis point,
    /// so every percent with up to 2 decimals is exact. A tie past 2 decimals can go either way,
    /// because percent × 100 is a binary product: 12.345 % gives 1 235, but 1.005 % gives 100.
    /// The custom slider's range is 0–50 %, so a percent outside it (only a test or a corrupted
    /// saved value can set one) counts as the nearest end, and NaN counts as 0.
    private var tipBasisPoints: Int {
        let basisPoints = (effectiveTipPercent * 100).rounded(.toNearestOrAwayFromZero)
        guard basisPoints > 0 else { return 0 } // false for NaN too
        return Int(min(basisPoints, Double(Self.maxTipBasisPoints)))
    }

    /// The tip before Tip ↑: bill × percent, rounded half-up to 1 minor unit, in Int math only.
    /// The bill is at most `AmountParser.maxMinorUnits` (10^15) and the percent at most 5 000
    /// basis points, so the product is at most 5 × 10^18 and can't overflow.
    private var rawTipMinorUnits: Int {
        // 10 000 basis points are 100 %; adding half of that before dividing rounds half-up.
        (billMinorUnits * tipBasisPoints + 5_000) / 10_000
    }

    /// The tip in minor units, rounded half-up to 1 minor unit; Tip ↑ rounds it up to a whole unit.
    var tipMinorUnits: Int {
        switch selectedRounding {
        case .roundTip: ShareAllocator.roundedUpToWholeUnit(rawTipMinorUnits, currency: selectedCurrency)
        default: rawTipMinorUnits
        }
    }

    /// The bill plus the tip in minor units; Total ↑ rounds it up to a whole unit.
    var totalMinorUnits: Int {
        switch selectedRounding {
        case .roundTotal: ShareAllocator.roundedUpToWholeUnit(billMinorUnits + rawTipMinorUnits, currency: selectedCurrency)
        default: billMinorUnits + tipMinorUnits
        }
    }

    var tipAmount: Double { selectedCurrency.amount(minorUnits: tipMinorUnits) }
    var totalAmount: Double { selectedCurrency.amount(minorUnits: totalMinorUnits) }

    var perPersonAmount: Double {
        switch selectedRounding {
        case .roundPerPerson:
            splitCount > 0 ? (totalAmount / Double(splitCount)).rounded(.up) : totalAmount
        default:
            splitCount > 0 ? totalAmount / Double(splitCount) : totalAmount
        }
    }

    var calculation: TipCalculation {
        TipCalculation(
            tipAmount: tipAmount,
            totalAmount: totalAmount,
            perPersonAmount: perPersonAmount,
            tipPercent: effectiveTipPercent,
            splitCount: splitCount
        )
    }

    // MARK: - Custom Split
    // A typed row pays what its text says. The automatic rows (`PersonSplit.isAutomatic(_:)`)
    // split what the typed rows leave of the bill (spec §3.1). Their amounts are computed here and
    // never written into `amountText`, so the app never changes typed text, and untouched rows
    // follow the bill, the head count, and the other rows.

    /// Each row's part of the bill before tip, in minor units of `selectedCurrency`: one per row,
    /// in `personSplits` order, in either mode. Recomputed on every read.
    ///
    /// - A typed row: its `AmountParser` value, or 0 while the parser rejects the text, above the
    ///   cap included (spec §3.2).
    /// - The automatic rows: max(0, bill − the typed rows' portions), split by `ShareAllocator`
    ///   with equal weights, so leftover units go to the lowest-numbered automatic rows. Bill
    ///   100,00 with 3 automatic rows → [3334, 3333, 3333]; bill 1 250,00 with Person 1 at 150 →
    ///   [15_000, 36_667, 36_667, 36_666].
    ///
    /// At most 20 rows, each at most `AmountParser.maxMinorUnits`, so the sums can't overflow.
    var billPortionsMinorUnits: [Int] {
        // nil for an automatic row.
        let typedPortions: [Int?] = personSplits.map { split in
            split.isAutomatic ? nil : AmountParser.minorUnits(from: split.amountText, currency: selectedCurrency) ?? 0
        }
        let typedTotal = typedPortions.reduce(0) { $0 + ($1 ?? 0) }
        let automaticRowCount = typedPortions.filter { $0 == nil }.count
        var automaticPortions = ShareAllocator.allocate(
            max(0, billMinorUnits - typedTotal),
            weights: Array(repeating: 1, count: automaticRowCount)
        ).makeIterator()
        // One portion per automatic row, in row order, so `next()` never runs out.
        return typedPortions.map { $0 ?? automaticPortions.next() ?? 0 }
    }

    /// What `split`'s field shows while the row is automatic: its bill portion as a number without
    /// the symbol, in the currency's format (spec §3.1), such as "1 500,00" or "1,500.00".
    ///
    /// Display only: it's never written into `amountText` and never parsed. A typed row shows its
    /// own text instead, so its value here goes unused. A row that isn't in `personSplits` gets 0.
    func automaticAmountText(for split: PersonSplit) -> String {
        let portion = personSplits.firstIndex { $0.id == split.id }.map { billPortionsMinorUnits[$0] } ?? 0
        return CurrencyFormatter.formatWithoutSymbol(minorUnits: portion, currency: selectedCurrency)
    }

    // MARK: - Init
    /// Restores the saved preferences from `defaults`, and `savePreferences()` writes them back there.
    /// The app and previews use `.standard`; tests pass a suite of their own.
    init(defaults: UserDefaults = .standard) {
        _savedCurrency = AppStorage(wrappedValue: "nok", "savedCurrency", store: defaults)
        _savedTip = AppStorage(wrappedValue: 3, "savedTip", store: defaults)
        _savedSplit = AppStorage(wrappedValue: 1, "savedSplit", store: defaults)
        _savedCustomTip = AppStorage(wrappedValue: 18.0, "savedCustomTip", store: defaults)
        _savedRounding = AppStorage(wrappedValue: 0, "savedRounding", store: defaults)

        if let currency = Currency(rawValue: savedCurrency) {
            selectedCurrency = currency
        }
        if let preset = TipPreset(rawValue: savedTip) {
            selectedPreset = preset
        }
        splitCount = savedSplit // clamped to 1…20, with one empty row per person
        customTipPercent = savedCustomTip
        if let rounding = RoundingMode(rawValue: savedRounding) {
            selectedRounding = rounding
        }
    }

    // MARK: - Methods
    func incrementSplit() {
        if splitCount < Self.splitCountRange.upperBound {
            splitCount += 1
            savePreferences()
        }
    }

    func decrementSplit() {
        if splitCount > Self.splitCountRange.lowerBound {
            splitCount -= 1
            savePreferences()
        }
    }

    func savePreferences() {
        savedCurrency = selectedCurrency.rawValue
        savedTip = selectedPreset.rawValue
        savedSplit = splitCount
        savedCustomTip = customTipPercent
        savedRounding = selectedRounding.rawValue
    }
}
