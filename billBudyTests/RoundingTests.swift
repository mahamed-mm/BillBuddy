import Testing
@testable import billBudy

// MARK: - Rounding Math

@Suite("CalculatorViewModel — Rounding")
struct RoundingTests {

    @Test("No rounding — existing behavior unchanged")
    func noRounding() {
        let vm = CalculatorViewModel()
        vm.billAmountText = "95"
        vm.selectedPreset = .fifteen
        vm.selectedRounding = .none
        #expect(vm.tipAmount == 14.25)
        #expect(vm.totalAmount == 109.25)
    }

    @Test("Round tip — $95 + 15% tip rounds tip from 14.25 to 15")
    func roundTip() {
        let vm = CalculatorViewModel()
        vm.billAmountText = "95"
        vm.selectedPreset = .fifteen
        vm.selectedRounding = .roundTip
        #expect(vm.tipAmount == 15.0)
        #expect(vm.totalAmount == 110.0) // bill + rounded tip
    }

    @Test("Round total — $95 + 15% rounds total from 109.25 to 110")
    func roundTotal() {
        let vm = CalculatorViewModel()
        vm.billAmountText = "95"
        vm.selectedPreset = .fifteen
        vm.selectedRounding = .roundTotal
        #expect(vm.tipAmount == 14.25) // tip stays raw
        #expect(vm.totalAmount == 110.0)
    }

    @Test("Round per person — $100 + 15% split 3 ways rounds from 38.33 to 39")
    func roundPerPerson() {
        let vm = CalculatorViewModel()
        vm.billAmountText = "100"
        vm.selectedPreset = .fifteen
        vm.splitCount = 3
        vm.selectedRounding = .roundPerPerson
        #expect(vm.perPersonAmount == 39.0)
    }

    @Test("Round tip with zero bill — stays zero")
    func roundTipZeroBill() {
        let vm = CalculatorViewModel()
        vm.billAmountText = "0"
        vm.selectedPreset = .fifteen
        vm.selectedRounding = .roundTip
        #expect(vm.tipAmount == 0.0)
        #expect(vm.totalAmount == 0.0)
    }

    @Test("Round total with exact amount — no change needed")
    func roundTotalExact() {
        let vm = CalculatorViewModel()
        vm.billAmountText = "100"
        vm.selectedPreset = .twenty
        vm.selectedRounding = .roundTotal
        // 100 + 20 = 120, already whole
        #expect(vm.totalAmount == 120.0)
    }

    @Test("Round per person with 1 person — same as total")
    func roundPerPersonSingle() {
        let vm = CalculatorViewModel()
        vm.billAmountText = "95"
        vm.selectedPreset = .fifteen
        vm.splitCount = 1
        vm.selectedRounding = .roundPerPerson
        // 109.25 / 1 rounded up = 110
        #expect(vm.perPersonAmount == 110.0)
    }

    @Test("Custom tip with rounding — 18% on $55")
    func customTipWithRounding() {
        let vm = CalculatorViewModel()
        vm.billAmountText = "55"
        vm.selectedPreset = .custom
        vm.customTipPercent = 18
        vm.selectedRounding = .roundTip
        // raw tip = 9.9, rounded up = 10
        #expect(vm.tipAmount == 10.0)
        #expect(vm.totalAmount == 65.0)
    }
}

// MARK: - RoundingMode Model

@Suite("RoundingMode")
struct RoundingModeTests {

    @Test("All cases exist (4 total)")
    func allCasesCount() {
        #expect(RoundingMode.allCases.count == 4)
    }

    @Test("Display text values")
    func displayText() {
        #expect(RoundingMode.none.displayText == "None")
        #expect(RoundingMode.roundTip.displayText == "Tip ↑")
        #expect(RoundingMode.roundTotal.displayText == "Total ↑")
        #expect(RoundingMode.roundPerPerson.displayText == "Per Person ↑")
    }

    @Test("Raw values for persistence")
    func rawValues() {
        #expect(RoundingMode.none.rawValue == 0)
        #expect(RoundingMode.roundTip.rawValue == 1)
        #expect(RoundingMode.roundTotal.rawValue == 2)
        #expect(RoundingMode.roundPerPerson.rawValue == 3)
    }
}
