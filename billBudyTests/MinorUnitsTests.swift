import Testing
@testable import billBudy

// MARK: - Exact Minor Units

@Suite("CalculatorViewModel — Minor Units")
struct MinorUnitsTests {
    private let defaults = TestDefaults()

    // MARK: Bill

    @Test("One bill source: billAmount derives from billMinorUnits, and the text stays as typed", arguments: [
        ("1.005", 101, 1.01), ("1,005", 101, 1.01), ("12,50", 1_250, 12.5), ("0.29", 29, 0.29),
        ("33.30", 3_330, 33.3), ("0,004", 0, 0.0), ("", 0, 0.0), ("abc", 0, 0.0),
        ("10000000000000", 1_000_000_000_000_000, 10_000_000_000_000.0),
    ])
    func oneBillSource(text: String, minorUnits: Int, amount: Double) {
        let vm = defaults.makeViewModel()
        vm.billAmountText = text
        #expect(vm.billMinorUnits == minorUnits)
        #expect(vm.billAmount == amount)
        #expect(vm.billAmountText == text)
    }

    @Test("The tip and total start from the bill as counted: \"1.005\" is 1,01")
    func resultsStartFromBillMinorUnits() {
        let vm = defaults.makeViewModel()
        vm.billAmountText = "1.005"
        vm.selectedPreset = .custom
        vm.customTipPercent = 50
        #expect(vm.tipMinorUnits == 51) // 50 % of 101 øre is 50,5 → 51 (of 100,5 øre it would be 50)
        #expect(vm.totalMinorUnits == 152)
        #expect(vm.totalAmount == 1.52)
    }

    @Test("Bill text above the cap computes as 0 in every rounding mode, like any rejected text", arguments: [
        "10000000000000,01", "92233720368547758,01", "10000000000000,005", "abc",
    ])
    func overCapBillIsZero(text: String) {
        let vm = defaults.makeViewModel()
        vm.billAmountText = text
        vm.selectedPreset = .fifteen
        vm.splitCount = 2
        for rounding in RoundingMode.allCases {
            vm.selectedRounding = rounding
            #expect(vm.billMinorUnits == 0)
            #expect(vm.tipMinorUnits == 0)
            #expect(vm.totalMinorUnits == 0)
            #expect(vm.billAmount == 0.0)
            #expect(vm.tipAmount == 0.0)
            #expect(vm.totalAmount == 0.0)
            #expect(vm.perPersonAmount == 0.0)
        }
        #expect(vm.billAmountText == text)
    }

    // MARK: Tip

    @Test("Bill 33.30 at 15 %: the half-øre tip rounds up to 5,00 kr, and the total is 38,30 kr")
    func halfOreTip() {
        let vm = defaults.makeViewModel()
        vm.billAmountText = "33.30"
        vm.selectedPreset = .fifteen
        #expect(vm.tipMinorUnits == 500)
        #expect(vm.totalMinorUnits == 3_830)
        #expect(vm.tipAmount == 5.0)
        #expect(vm.totalAmount == 38.3)
        // Double math gave 4,99499… and 38,29499…, shown as "4,99 kr" and "38,29 kr".
        #expect(CurrencyFormatter.format(amount: vm.tipAmount, currency: .nok).contains("5,00"))
        #expect(CurrencyFormatter.format(amount: vm.totalAmount, currency: .nok).contains("38,30"))
    }

    @Test("The tip rounds to the nearest øre, and exactly half an øre rounds up", arguments: [
        ("0.10", TipPreset.five, 1), // 0,5 øre: a tie → 1 (half-even and truncation give 0)
        ("1.10", .fifteen, 17),      // 16,5 øre: a tie → 17 (half-even gives 16)
        ("0.30", .five, 2),          // 1,5 øre: a tie → 2
        ("33.30", .fifteen, 500),    // 499,5 øre: a tie → 500
        ("0.01", .fifteen, 0),       // 0,15 øre
        ("0.03", .fifteen, 0),       // 0,45 øre
        ("0.04", .fifteen, 1),       // 0,6 øre
        ("999999.99", .fifteen, 15_000_000), // 14 999 999,85 øre
    ])
    func tipRoundsHalfUp(bill: String, preset: TipPreset, tip: Int) {
        let vm = defaults.makeViewModel()
        vm.billAmountText = bill
        vm.selectedPreset = preset
        #expect(vm.tipMinorUnits == tip)
        #expect(vm.totalMinorUnits == vm.billMinorUnits + tip)
    }

    @Test("Fractional custom percents are exact to 0.01 %, and a tie still rounds up", arguments: [
        (12.5, "1", 13),      // 12,5 øre: a tie → 13 (Double math gave 0.125, shown as 0,12)
        (17.5, "33.30", 583), // 582,75 øre
        (12.34, "100", 1_234),
        (0.01, "100", 1),
        (33.33, "3", 100),    // 99,99 øre
        (49.99, "0.01", 0),   // 0,4999 øre
    ])
    func fractionalPercent(percent: Double, bill: String, tip: Int) {
        let vm = defaults.makeViewModel()
        vm.billAmountText = bill
        vm.selectedPreset = .custom
        vm.customTipPercent = percent
        #expect(vm.tipMinorUnits == tip)
        #expect(vm.totalMinorUnits == vm.billMinorUnits + tip)
    }

    // The slider sets whole percents, so this only matters for tests and corrupted saved values.
    // A tie past 2 decimals can go either way, because percent × 100 is a binary product.
    @Test("A percent with more than 2 decimals counts to the nearest basis point", arguments: [
        (12.346, [123_500]),          // 12,35 % of 10 000 kr (12,346 % would be 123 460 øre)
        (12.344, [123_400]),          // 12,34 %
        (0.006, [100]),               // 0,01 %
        (0.004, [0]),                 // 0,00 %
        (12.345, [123_400, 123_500]), // a tie: 12.345 × 100 is exactly 1234.5, so it goes up
        (1.005, [10_000, 10_100]),    // a tie: 1.005 × 100 is just under 100.5, so it goes down
    ])
    func percentToBasisPoints(percent: Double, tips: [Int]) {
        let vm = defaults.makeViewModel()
        vm.billAmountText = "10000"
        vm.selectedPreset = .custom
        vm.customTipPercent = percent
        #expect(tips.contains(vm.tipMinorUnits))
    }

    @Test("A custom percent outside the slider's 0–50 % counts as the nearest end, and NaN as 0")
    func percentOutsideSliderRange() {
        let vm = defaults.makeViewModel()
        vm.billAmountText = "100"
        vm.selectedPreset = .custom
        let cases: [(percent: Double, tip: Int)] = [
            (-5, 0), (-.infinity, 0), (.nan, 0), (50, 5_000), (60, 5_000), (.infinity, 5_000),
        ]
        for (percent, tip) in cases {
            vm.customTipPercent = percent
            #expect(vm.tipMinorUnits == tip, "\(percent) %")
            #expect(vm.totalMinorUnits == 10_000 + tip, "\(percent) %")
        }
    }

    // MARK: Rounding modes

    @Test("Tip ↑ and Total ↑ round the exact minor units up; Per Person ↑ starts from the exact total")
    func roundingModesStartFromExactUnits() {
        let vm = defaults.makeViewModel()
        vm.billAmountText = "33.30"
        vm.selectedPreset = .fifteen
        vm.splitCount = 2

        vm.selectedRounding = .roundTip
        #expect(vm.tipMinorUnits == 500) // whole already
        #expect(vm.totalMinorUnits == 3_830)

        vm.selectedRounding = .roundTotal
        #expect(vm.tipMinorUnits == 500)
        #expect(vm.totalMinorUnits == 3_900)

        vm.selectedRounding = .roundPerPerson
        #expect(vm.totalMinorUnits == 3_830)
        #expect(vm.perPersonAmount == 20.0) // 19,15 rounded up

        vm.selectedRounding = .none
        #expect(vm.perPersonAmount == 19.15)
    }

    @Test("Tip ↑ and Total ↑ round the amounts as shown, never a leftover fraction of an øre")
    func roundingIgnoresSubOreRemainders() {
        let vm = defaults.makeViewModel()
        vm.selectedPreset = .fifteen

        // 15 % of 6,67 is 1,0005: the tip shows 1,00, and Tip ↑ keeps it (Double math gave 2,00).
        vm.billAmountText = "6.67"
        vm.selectedRounding = .roundTip
        #expect(vm.tipMinorUnits == 100)
        #expect(vm.totalMinorUnits == 767)

        // 0,87 plus 15 % is 1,0005: the total shows 1,00, and Total ↑ keeps it (Double math gave 2,00).
        vm.billAmountText = "0.87"
        vm.selectedRounding = .roundTotal
        #expect(vm.tipMinorUnits == 13)
        #expect(vm.totalMinorUnits == 100)
    }

    // MARK: Cap

    @Test("At the cap with a 50 % tip and 20 people, every rounding mode is exact and nothing overflows")
    func billAtCap() {
        let vm = defaults.makeViewModel()
        vm.billAmountText = "10000000000000"
        vm.selectedPreset = .custom
        vm.customTipPercent = 50
        vm.splitCount = 20
        for rounding in RoundingMode.allCases {
            vm.selectedRounding = rounding
            #expect(vm.billMinorUnits == 1_000_000_000_000_000)
            #expect(vm.tipMinorUnits == 500_000_000_000_000)
            #expect(vm.totalMinorUnits == 1_500_000_000_000_000)
            #expect(vm.tipAmount == 5_000_000_000_000.0)
            #expect(vm.totalAmount == 15_000_000_000_000.0)
            #expect(vm.perPersonAmount == 750_000_000_000.0)
        }
    }

    @Test("Just under the cap, the half-up tip, Tip ↑, and Total ↑ stay exact")
    func billJustUnderCap() {
        let vm = defaults.makeViewModel()
        vm.billAmountText = "9999999999999,99"
        vm.selectedPreset = .custom
        vm.customTipPercent = 50
        #expect(vm.tipMinorUnits == 500_000_000_000_000) // 499 999 999 999 999,5 øre: a tie → up
        #expect(vm.totalMinorUnits == 1_499_999_999_999_999)
        #expect(vm.totalAmount == 14_999_999_999_999.99)

        vm.selectedRounding = .roundTip
        #expect(vm.tipMinorUnits == 500_000_000_000_000)
        #expect(vm.totalMinorUnits == 1_499_999_999_999_999)

        vm.selectedRounding = .roundTotal
        #expect(vm.totalMinorUnits == 1_500_000_000_000_000)
    }
}
