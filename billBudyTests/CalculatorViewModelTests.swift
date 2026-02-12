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

    @Test("15% tip on $100")
    func fifteenPercentOnHundred() {
        let vm = CalculatorViewModel()
        vm.billAmountText = "100"
        vm.selectedPreset = .fifteen
        #expect(vm.tipAmount == 15.0)
        #expect(vm.totalAmount == 115.0)
    }

    @Test("0% tip")
    func zeroPercent() {
        let vm = CalculatorViewModel()
        vm.billAmountText = "100"
        vm.selectedPreset = .zero
        #expect(vm.tipAmount == 0.0)
        #expect(vm.totalAmount == 100.0)
    }

    @Test("25% tip on $200")
    func twentyFivePercentOnTwoHundred() {
        let vm = CalculatorViewModel()
        vm.billAmountText = "200"
        vm.selectedPreset = .twentyFive
        #expect(vm.tipAmount == 50.0)
        #expect(vm.totalAmount == 250.0)
    }

    @Test("Custom 18% tip")
    func customEighteenPercent() {
        let vm = CalculatorViewModel()
        vm.billAmountText = "100"
        vm.selectedPreset = .custom
        vm.customTipPercent = 18
        #expect(vm.tipAmount == 18.0)
        #expect(vm.totalAmount == 118.0)
    }

    @Test("Custom 0% tip")
    func customZeroPercent() {
        let vm = CalculatorViewModel()
        vm.billAmountText = "100"
        vm.selectedPreset = .custom
        vm.customTipPercent = 0
        #expect(vm.tipAmount == 0.0)
        #expect(vm.totalAmount == 100.0)
    }

    @Test("Custom 50% tip")
    func customFiftyPercent() {
        let vm = CalculatorViewModel()
        vm.billAmountText = "100"
        vm.selectedPreset = .custom
        vm.customTipPercent = 50
        #expect(vm.tipAmount == 50.0)
        #expect(vm.totalAmount == 150.0)
    }

    @Test("5% tip on $80")
    func fivePercentOnEighty() {
        let vm = CalculatorViewModel()
        vm.billAmountText = "80"
        vm.selectedPreset = .five
        #expect(vm.tipAmount == 4.0)
        #expect(vm.totalAmount == 84.0)
    }

    @Test("10% tip on $50")
    func tenPercentOnFifty() {
        let vm = CalculatorViewModel()
        vm.billAmountText = "50"
        vm.selectedPreset = .ten
        #expect(vm.tipAmount == 5.0)
        #expect(vm.totalAmount == 55.0)
    }

    @Test("20% tip on $75")
    func twentyPercentOnSeventyFive() {
        let vm = CalculatorViewModel()
        vm.billAmountText = "75"
        vm.selectedPreset = .twenty
        #expect(vm.tipAmount == 15.0)
        #expect(vm.totalAmount == 90.0)
    }

    @Test("effectiveTipPercent uses preset when not custom")
    func effectiveTipPercentPreset() {
        let vm = CalculatorViewModel()
        vm.selectedPreset = .twenty
        #expect(vm.effectiveTipPercent == 20.0)
    }

    @Test("effectiveTipPercent uses customTipPercent when custom")
    func effectiveTipPercentCustom() {
        let vm = CalculatorViewModel()
        vm.selectedPreset = .custom
        vm.customTipPercent = 33
        #expect(vm.effectiveTipPercent == 33.0)
    }
}

// MARK: - Split Math

@Suite("CalculatorViewModel — Split Math")
struct SplitMathTests {

    @Test("No split (1 person)")
    func noSplit() {
        let vm = CalculatorViewModel()
        vm.billAmountText = "100"
        vm.selectedPreset = .fifteen
        vm.splitCount = 1
        #expect(vm.perPersonAmount == 115.0)
    }

    @Test("Split by 2")
    func splitByTwo() {
        let vm = CalculatorViewModel()
        vm.billAmountText = "100"
        vm.selectedPreset = .fifteen
        vm.splitCount = 2
        #expect(vm.perPersonAmount == 57.5)
    }

    @Test("Split by 3 (repeating decimal)")
    func splitByThree() {
        let vm = CalculatorViewModel()
        vm.billAmountText = "100"
        vm.selectedPreset = .zero
        vm.splitCount = 3
        #expect(vm.perPersonAmount.isNear(33.333333, tolerance: 0.001))
    }

    @Test("Split by 20 (max)")
    func splitByTwenty() {
        let vm = CalculatorViewModel()
        vm.billAmountText = "100"
        vm.selectedPreset = .zero
        vm.splitCount = 20
        #expect(vm.perPersonAmount == 5.0)
    }

    @Test("incrementSplit increases count")
    func incrementSplit() {
        let vm = CalculatorViewModel()
        vm.splitCount = 5
        vm.incrementSplit()
        #expect(vm.splitCount == 6)
    }

    @Test("decrementSplit decreases count")
    func decrementSplit() {
        let vm = CalculatorViewModel()
        vm.splitCount = 5
        vm.decrementSplit()
        #expect(vm.splitCount == 4)
    }

    @Test("incrementSplit clamped at 20")
    func incrementSplitMax() {
        let vm = CalculatorViewModel()
        vm.splitCount = 20
        vm.incrementSplit()
        #expect(vm.splitCount == 20)
    }

    @Test("decrementSplit clamped at 1")
    func decrementSplitMin() {
        let vm = CalculatorViewModel()
        vm.splitCount = 1
        vm.decrementSplit()
        #expect(vm.splitCount == 1)
    }
}

// MARK: - Edge Cases

@Suite("CalculatorViewModel — Edge Cases")
struct EdgeCaseTests {

    @Test("Empty bill amount")
    func emptyBill() {
        let vm = CalculatorViewModel()
        vm.billAmountText = ""
        #expect(vm.billAmount == 0.0)
        #expect(vm.tipAmount == 0.0)
        #expect(vm.totalAmount == 0.0)
        #expect(vm.perPersonAmount == 0.0)
    }

    @Test("Zero bill")
    func zeroBill() {
        let vm = CalculatorViewModel()
        vm.billAmountText = "0"
        #expect(vm.billAmount == 0.0)
        #expect(vm.tipAmount == 0.0)
        #expect(vm.totalAmount == 0.0)
    }

    @Test("Invalid input")
    func invalidInput() {
        let vm = CalculatorViewModel()
        vm.billAmountText = "abc"
        #expect(vm.billAmount == 0.0)
    }

    @Test("Very large bill")
    func veryLargeBill() {
        let vm = CalculatorViewModel()
        vm.billAmountText = "999999.99"
        vm.selectedPreset = .fifteen
        #expect(vm.billAmount == 999999.99)
        #expect(vm.tipAmount.isNear(149999.9985, tolerance: 0.01))
        #expect(vm.totalAmount.isNear(1149999.9885, tolerance: 0.01))
    }

    @Test("Decimal input")
    func decimalInput() {
        let vm = CalculatorViewModel()
        vm.billAmountText = "42.50"
        #expect(vm.billAmount == 42.5)
    }

    @Test("calculation snapshot bundles all values")
    func calculationSnapshot() {
        let vm = CalculatorViewModel()
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
}
