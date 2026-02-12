import Testing
@testable import billBudy

@Suite("CalculatorViewModel Tests")
struct CalculatorViewModelTests {

    @Test("Default state")
    func defaultState() {
        let vm = CalculatorViewModel()
        #expect(vm.billAmountText == "")
        #expect(vm.billAmount == 0.0)
    }
}
