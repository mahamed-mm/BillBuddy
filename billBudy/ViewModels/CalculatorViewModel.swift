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
    @ObservationIgnored @AppStorage("savedCurrency") private var savedCurrency: String = "nok"
    @ObservationIgnored @AppStorage("savedTip") private var savedTip: Int = 3
    @ObservationIgnored @AppStorage("savedSplit") private var savedSplit: Int = 1
    @ObservationIgnored @AppStorage("savedCustomTip") private var savedCustomTip: Double = 18.0
    @ObservationIgnored @AppStorage("savedRounding") private var savedRounding: Int = 0

    // MARK: - Computed Properties
    var billAmount: Double { Double(billAmountText) ?? 0.0 }
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
    init() {
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
