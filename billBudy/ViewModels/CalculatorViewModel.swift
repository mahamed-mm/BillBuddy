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
    var billAmount: Double { AmountParser.amount(from: billAmountText) ?? 0.0 }
    var effectiveTipPercent: Double { selectedPreset == .custom ? customTipPercent : selectedPreset.percentage }

    private var rawTipAmount: Double { billAmount * effectiveTipPercent / 100 }
    private var rawTotalAmount: Double { billAmount + rawTipAmount }
    private var rawPerPersonAmount: Double { splitCount > 0 ? rawTotalAmount / Double(splitCount) : rawTotalAmount }

    var tipAmount: Double {
        switch selectedRounding {
        case .roundTip: rawTipAmount.rounded(.up)
        default: rawTipAmount
        }
    }

    var totalAmount: Double {
        switch selectedRounding {
        case .roundTip: billAmount + tipAmount
        case .roundTotal: rawTotalAmount.rounded(.up)
        default: rawTotalAmount
        }
    }

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
