import Foundation
import Testing
@testable import billBudy

private extension Double {
    func isNear(_ other: Double, tolerance: Double) -> Bool {
        abs(self - other) <= tolerance
    }
}

// MARK: - Tip Math

@Suite("CalculatorViewModel — Tip Math")
struct TipMathTests {
    private let defaults = TestDefaults()

    @Test("15% tip on $100")
    func fifteenPercentOnHundred() {
        let vm = defaults.makeViewModel()
        vm.billAmountText = "100"
        vm.selectedPreset = .fifteen
        #expect(vm.tipAmount == 15.0)
        #expect(vm.totalAmount == 115.0)
    }

    @Test("0% tip")
    func zeroPercent() {
        let vm = defaults.makeViewModel()
        vm.billAmountText = "100"
        vm.selectedPreset = .zero
        #expect(vm.tipAmount == 0.0)
        #expect(vm.totalAmount == 100.0)
    }

    @Test("25% tip on $200")
    func twentyFivePercentOnTwoHundred() {
        let vm = defaults.makeViewModel()
        vm.billAmountText = "200"
        vm.selectedPreset = .twentyFive
        #expect(vm.tipAmount == 50.0)
        #expect(vm.totalAmount == 250.0)
    }

    @Test("Custom 18% tip")
    func customEighteenPercent() {
        let vm = defaults.makeViewModel()
        vm.billAmountText = "100"
        vm.selectedPreset = .custom
        vm.customTipPercent = 18
        #expect(vm.tipAmount == 18.0)
        #expect(vm.totalAmount == 118.0)
    }

    @Test("Custom 0% tip")
    func customZeroPercent() {
        let vm = defaults.makeViewModel()
        vm.billAmountText = "100"
        vm.selectedPreset = .custom
        vm.customTipPercent = 0
        #expect(vm.tipAmount == 0.0)
        #expect(vm.totalAmount == 100.0)
    }

    @Test("Custom 50% tip")
    func customFiftyPercent() {
        let vm = defaults.makeViewModel()
        vm.billAmountText = "100"
        vm.selectedPreset = .custom
        vm.customTipPercent = 50
        #expect(vm.tipAmount == 50.0)
        #expect(vm.totalAmount == 150.0)
    }

    @Test("5% tip on $80")
    func fivePercentOnEighty() {
        let vm = defaults.makeViewModel()
        vm.billAmountText = "80"
        vm.selectedPreset = .five
        #expect(vm.tipAmount == 4.0)
        #expect(vm.totalAmount == 84.0)
    }

    @Test("10% tip on $50")
    func tenPercentOnFifty() {
        let vm = defaults.makeViewModel()
        vm.billAmountText = "50"
        vm.selectedPreset = .ten
        #expect(vm.tipAmount == 5.0)
        #expect(vm.totalAmount == 55.0)
    }

    @Test("20% tip on $75")
    func twentyPercentOnSeventyFive() {
        let vm = defaults.makeViewModel()
        vm.billAmountText = "75"
        vm.selectedPreset = .twenty
        #expect(vm.tipAmount == 15.0)
        #expect(vm.totalAmount == 90.0)
    }

    @Test("effectiveTipPercent uses preset when not custom")
    func effectiveTipPercentPreset() {
        let vm = defaults.makeViewModel()
        vm.selectedPreset = .twenty
        #expect(vm.effectiveTipPercent == 20.0)
    }

    @Test("effectiveTipPercent uses customTipPercent when custom")
    func effectiveTipPercentCustom() {
        let vm = defaults.makeViewModel()
        vm.selectedPreset = .custom
        vm.customTipPercent = 33
        #expect(vm.effectiveTipPercent == 33.0)
    }
}

// MARK: - Split Math

@Suite("CalculatorViewModel — Split Math")
struct SplitMathTests {
    private let defaults = TestDefaults()

    @Test("No split (1 person)")
    func noSplit() {
        let vm = defaults.makeViewModel()
        vm.billAmountText = "100"
        vm.selectedPreset = .fifteen
        vm.splitCount = 1
        #expect(vm.perPersonAmount == 115.0)
    }

    @Test("Split by 2")
    func splitByTwo() {
        let vm = defaults.makeViewModel()
        vm.billAmountText = "100"
        vm.selectedPreset = .fifteen
        vm.splitCount = 2
        #expect(vm.perPersonAmount == 57.5)
    }

    @Test("Split by 3 (repeating decimal)")
    func splitByThree() {
        let vm = defaults.makeViewModel()
        vm.billAmountText = "100"
        vm.selectedPreset = .zero
        vm.splitCount = 3
        #expect(vm.perPersonAmount.isNear(33.333333, tolerance: 0.001))
    }

    @Test("Split by 20 (max)")
    func splitByTwenty() {
        let vm = defaults.makeViewModel()
        vm.billAmountText = "100"
        vm.selectedPreset = .zero
        vm.splitCount = 20
        #expect(vm.perPersonAmount == 5.0)
    }

    @Test("incrementSplit increases count")
    func incrementSplit() {
        let vm = defaults.makeViewModel()
        vm.splitCount = 5
        vm.incrementSplit()
        #expect(vm.splitCount == 6)
    }

    @Test("decrementSplit decreases count")
    func decrementSplit() {
        let vm = defaults.makeViewModel()
        vm.splitCount = 5
        vm.decrementSplit()
        #expect(vm.splitCount == 4)
    }

    @Test("incrementSplit clamped at 20")
    func incrementSplitMax() {
        let vm = defaults.makeViewModel()
        vm.splitCount = 20
        vm.incrementSplit()
        #expect(vm.splitCount == 20)
    }

    @Test("decrementSplit clamped at 1")
    func decrementSplitMin() {
        let vm = defaults.makeViewModel()
        vm.splitCount = 1
        vm.decrementSplit()
        #expect(vm.splitCount == 1)
    }
}

// MARK: - Edge Cases

@Suite("CalculatorViewModel — Edge Cases")
struct EdgeCaseTests {
    private let defaults = TestDefaults()

    @Test("Empty bill amount")
    func emptyBill() {
        let vm = defaults.makeViewModel()
        vm.billAmountText = ""
        #expect(vm.billAmount == 0.0)
        #expect(vm.tipAmount == 0.0)
        #expect(vm.totalAmount == 0.0)
        #expect(vm.perPersonAmount == 0.0)
    }

    @Test("Zero bill")
    func zeroBill() {
        let vm = defaults.makeViewModel()
        vm.billAmountText = "0"
        #expect(vm.billAmount == 0.0)
        #expect(vm.tipAmount == 0.0)
        #expect(vm.totalAmount == 0.0)
    }

    @Test("Invalid input")
    func invalidInput() {
        let vm = defaults.makeViewModel()
        vm.billAmountText = "abc"
        #expect(vm.billAmount == 0.0)
    }

    @Test("Very large bill")
    func veryLargeBill() {
        let vm = defaults.makeViewModel()
        vm.billAmountText = "999999.99"
        vm.selectedPreset = .fifteen
        #expect(vm.billAmount == 999999.99)
        #expect(vm.tipAmount.isNear(149999.9985, tolerance: 0.01))
        #expect(vm.totalAmount.isNear(1149999.9885, tolerance: 0.01))
    }

    @Test("Decimal input")
    func decimalInput() {
        let vm = defaults.makeViewModel()
        vm.billAmountText = "42.50"
        #expect(vm.billAmount == 42.5)
    }

    @Test("calculation snapshot bundles all values")
    func calculationSnapshot() {
        let vm = defaults.makeViewModel()
        vm.billAmountText = "100"
        vm.selectedPreset = .twenty
        vm.splitCount = 4
        let calc = vm.calculation
        #expect(calc.tipAmount == 20.0)
        #expect(calc.totalAmount == 120.0)
        #expect(calc.perPersonAmount == 30.0)
        #expect(calc.tipPercent == 20.0)
        #expect(calc.splitCount == 4)
    }
}

// MARK: - Persistence

@Suite("CalculatorViewModel — Persistence")
struct PersistenceTests {
    private let defaults = TestDefaults()

    @Test("A view model on a new store starts with the default preferences")
    func newStoreGivesDefaults() {
        let vm = defaults.makeViewModel()
        #expect(vm.selectedCurrency == .nok)
        #expect(vm.selectedPreset == .fifteen)
        #expect(vm.customTipPercent == 18.0)
        #expect(vm.splitCount == 1)
        #expect(vm.selectedRounding == .none)
    }

    @Test("Saved preferences come back in a new view model on the same store")
    func savedPreferencesRoundTrip() {
        let store = defaults.makeStore()
        let saved = CalculatorViewModel(defaults: store)
        saved.billAmountText = "100"
        saved.selectedCurrency = .usd
        saved.selectedPreset = .custom
        saved.customTipPercent = 33
        saved.splitCount = 7
        saved.selectedRounding = .roundPerPerson
        saved.savePreferences()

        let restored = CalculatorViewModel(defaults: store)
        #expect(restored.selectedCurrency == .usd)
        #expect(restored.selectedPreset == .custom)
        #expect(restored.customTipPercent == 33.0)
        #expect(restored.splitCount == 7)
        #expect(restored.selectedRounding == .roundPerPerson)
        #expect(restored.billAmountText.isEmpty) // the bill isn't a preference
    }

    @Test("Saving writes all 5 preferences to the injected store and none to the standard defaults")
    func savingLeavesStandardDefaultsAlone() {
        let keys = ["savedCurrency", "savedTip", "savedSplit", "savedCustomTip", "savedRounding"]
        let standardBefore = keys.map { UserDefaults.standard.object(forKey: $0) as? NSObject }
        let store = defaults.makeStore()
        let vm = CalculatorViewModel(defaults: store)
        vm.selectedCurrency = .kes
        vm.selectedPreset = .twentyFive
        vm.customTipPercent = 42
        vm.splitCount = 9
        vm.selectedRounding = .roundTip
        vm.savePreferences()

        #expect(keys.allSatisfy { store.object(forKey: $0) != nil })
        #expect(keys.map { UserDefaults.standard.object(forKey: $0) as? NSObject } == standardBefore)
    }

    @Test("Stores are separate, and each is removed when its TestDefaults is released")
    func storesAreSeparateAndRemoved() {
        let store: UserDefaults
        do {
            let testDefaults = TestDefaults()
            store = testDefaults.makeStore()
            store.set(2, forKey: "savedRounding")
            #expect(store.integer(forKey: "savedRounding") == 2)
            #expect(testDefaults.makeStore().object(forKey: "savedRounding") == nil)
        } // released here, as each test's TestDefaults is when the test ends
        #expect(store.object(forKey: "savedRounding") == nil)
    }
}

// MARK: - Model Tests

@Suite("TipPreset")
struct TipPresetTests {

    @Test("All cases exist (7 total)")
    func allCasesCount() {
        #expect(TipPreset.allCases.count == 7)
    }

    @Test("Percentage values")
    func percentages() {
        #expect(TipPreset.zero.percentage == 0.0)
        #expect(TipPreset.five.percentage == 5.0)
        #expect(TipPreset.ten.percentage == 10.0)
        #expect(TipPreset.fifteen.percentage == 15.0)
        #expect(TipPreset.twenty.percentage == 20.0)
        #expect(TipPreset.twentyFive.percentage == 25.0)
        #expect(TipPreset.custom.percentage == 0.0)
    }

    @Test("Display text")
    func displayText() {
        #expect(TipPreset.fifteen.displayText == "15%")
        #expect(TipPreset.zero.displayText == "0%")
        #expect(TipPreset.custom.displayText == "Custom")
    }
}

@Suite("Currency")
struct CurrencyTests {

    @Test("All cases exist (3 total)")
    func allCasesCount() {
        #expect(Currency.allCases.count == 3)
    }

    @Test("NOK properties")
    func nokProperties() {
        #expect(Currency.nok.symbol == "kr")
        #expect(Currency.nok.locale == "nb_NO")
    }

    @Test("USD properties")
    func usdProperties() {
        #expect(Currency.usd.symbol == "$")
        #expect(Currency.usd.locale == "en_US")
    }

    @Test("KES properties")
    func kesProperties() {
        #expect(Currency.kes.symbol == "KSh")
        #expect(Currency.kes.locale == "en_KE")
    }

    // MARK: Minor units → Double

    @Test("amount(minorUnits:) gives whole units in every 2-decimal currency", arguments: [
        (0, 0.0), (1, 0.01), (29, 0.29), (101, 1.01), (500, 5.0), (3_830, 38.3), (42_167, 421.67),
        (99_999_999, 999_999.99), (1_000_000_000_000_000, 10_000_000_000_000.0),
    ])
    func amountFromMinorUnits(minorUnits: Int, expected: Double) {
        for currency in Currency.allCases where currency.fractionDigits == 2 {
            #expect(currency.amount(minorUnits: minorUnits) == expected)
        }
    }

    @Test("The scale comes from fractionDigits")
    func scaleFromFractionDigits() {
        #expect(Currency.amount(minorUnits: 1_234, fractionDigits: 0) == 1_234.0)
        #expect(Currency.amount(minorUnits: 1_234, fractionDigits: 1) == 123.4)
        #expect(Currency.amount(minorUnits: 1_234, fractionDigits: 3) == 1.234)
        #expect(Currency.amount(minorUnits: 5, fractionDigits: 3) == 0.005)
    }

    @Test("A negative scale counts as 0")
    func negativeScale() {
        #expect(Currency.amount(minorUnits: 1_234, fractionDigits: -1) == 1_234.0)
    }

    @Test("Gives the Double nearest the decimal amount at both documented bounds: 2^53 minor units and 22 digits")
    func exactAtBounds() {
        #expect(Currency.amount(minorUnits: 1 << 53, fractionDigits: 0) == 9_007_199_254_740_992.0)
        #expect(Currency.amount(minorUnits: 1 << 53, fractionDigits: 2) == 90_071_992_547_409.92)
        #expect(Currency.amount(minorUnits: 12_345, fractionDigits: 22) == 1.2345e-18)
    }
}
