import SwiftUI

@Observable
final class CalculatorViewModel {
    // MARK: - Input Properties
    var billAmountText: String = ""
    var selectedPreset: TipPreset = .fifteen
    var customTipPercent: Double = 18.0
    var splitCount: Int = 1
    var selectedCurrency: Currency = .nok
    var selectedRounding: RoundingMode = .none

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

    /// `effectiveTipPercent` in basis points (hundredths of a percent), rounded half-up, so every
    /// percent with up to 2 decimals is exact. The custom slider's range is 0–50 %, so a percent
    /// outside it (only a test or a corrupted saved value can set one) counts as the nearest end,
    /// and NaN counts as 0.
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
        splitCount = savedSplit
        customTipPercent = savedCustomTip
        if let rounding = RoundingMode(rawValue: savedRounding) {
            selectedRounding = rounding
        }
    }

    // MARK: - Methods
    func incrementSplit() {
        if splitCount < 20 {
            splitCount += 1
            savePreferences()
        }
    }

    func decrementSplit() {
        if splitCount > 1 {
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
