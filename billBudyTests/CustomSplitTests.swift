import Foundation
import Testing
@testable import billBudy

// MARK: - Rows

@Suite("CalculatorViewModel — Custom Split Rows")
struct CustomSplitRowTests {
    private let defaults = TestDefaults()

    /// A view model on a new store whose saved head count is `savedSplit`, as after a relaunch.
    private func makeViewModel(savedSplit: Int) -> CalculatorViewModel {
        let store = defaults.makeStore()
        store.set(savedSplit, forKey: "savedSplit")
        return CalculatorViewModel(defaults: store)
    }

    @Test("A new view model starts in Equal mode, with one empty row per restored person (Q4)", arguments: [1, 4, 20])
    func startsInEqualModeWithEmptyRows(savedSplit: Int) {
        let vm = makeViewModel(savedSplit: savedSplit)
        #expect(vm.splitMode == .equal)
        #expect(vm.splitCount == savedSplit)
        #expect(vm.personSplits.map(\.personNumber) == Array(1...savedSplit))
        #expect(vm.personSplits.allSatisfy { $0.amountText.isEmpty && $0.isAutomatic })
    }

    @Test("A saved head count outside 1…20 restores as the nearest end, with one row per person", arguments: [
        (0, 1), (-3, 1), (Int.min, 1), (21, 20), (1_000, 20), (Int.max, 20),
    ])
    func restoredCountIsClamped(savedSplit: Int, expected: Int) {
        let vm = makeViewModel(savedSplit: savedSplit)
        #expect(vm.splitCount == expected)
        #expect(vm.personSplits.map(\.personNumber) == Array(1...expected))
    }

    @Test("The mode and the amounts aren't saved, and saving writes no new keys (Q4)")
    func modeAndAmountsAreNotSaved() {
        let store = defaults.makeStore()
        let keysBefore = Set(store.dictionaryRepresentation().keys)
        let vm = CalculatorViewModel(defaults: store)
        vm.splitMode = .custom
        vm.incrementSplit()
        vm.incrementSplit()
        vm.personSplits[0].amountText = "150"
        vm.savePreferences()

        let relaunched = CalculatorViewModel(defaults: store)
        #expect(relaunched.splitMode == .equal)
        #expect(relaunched.splitCount == 3) // the head count is a saved preference, as before
        #expect(relaunched.personSplits.allSatisfy { $0.amountText.isEmpty })
        let keysAdded = Set(store.dictionaryRepresentation().keys).subtracting(keysBefore)
        #expect(keysAdded == ["savedCurrency", "savedTip", "savedSplit", "savedCustomTip", "savedRounding"])
    }

    @Test("Direct assignment clamps to 1…20 and leaves one row per person, numbered in order, in either mode", arguments: [
        (1, 1), (7, 7), (20, 20), (0, 1), (-3, 1), (Int.min, 1), (21, 20), (Int.max, 20),
    ])
    func directAssignment(count: Int, expected: Int) {
        for mode in SplitMode.allCases {
            let vm = defaults.makeViewModel()
            vm.splitMode = mode
            vm.splitCount = 5
            vm.splitCount = count
            #expect(vm.splitCount == expected, "\(mode)")
            #expect(vm.personSplits.count == expected, "\(mode)")
            #expect(vm.personSplits.map(\.personNumber) == Array(1...expected), "\(mode)")
        }
    }

    @Test("Direct assignment appends empty rows or removes the last ones, and the rows it keeps keep their ids and text")
    func directAssignmentKeepsOtherRows() {
        let vm = defaults.makeViewModel()
        vm.splitCount = 5
        for index in vm.personSplits.indices {
            vm.personSplits[index].amountText = "\(index + 1)0"
        }
        let rows = vm.personSplits

        vm.splitCount = 3
        #expect(vm.personSplits == Array(rows.prefix(3)))

        vm.splitCount = 3
        #expect(vm.personSplits == Array(rows.prefix(3)))

        vm.splitCount = 6
        #expect(Array(vm.personSplits.prefix(3)) == Array(rows.prefix(3)))
        #expect(vm.personSplits.map(\.amountText) == ["10", "20", "30", "", "", ""])
        #expect(vm.personSplits.map(\.personNumber) == Array(1...6))
        // Persons 4 and 5 are new rows, so focus kept on a removed row's id can't land on them.
        #expect(Set(vm.personSplits.map(\.id)).isDisjoint(with: rows.suffix(2).map(\.id)))
    }

    @Test("+ appends an empty, automatic row, and the other rows keep their ids and text (spec §3.1a, E5)")
    func incrementAppendsAutomaticRow() {
        let vm = defaults.makeViewModel()
        vm.splitMode = .custom
        vm.splitCount = 3
        vm.personSplits[0].amountText = "150"
        vm.personSplits[2].amountText = "abc"
        let rows = vm.personSplits

        vm.incrementSplit()

        #expect(vm.splitCount == 4)
        #expect(Array(vm.personSplits.prefix(3)) == rows)
        #expect(vm.personSplits[3].personNumber == 4)
        #expect(vm.personSplits[3].amountText.isEmpty)
        #expect(vm.personSplits[3].isAutomatic)
        #expect(!rows.map(\.id).contains(vm.personSplits[3].id))
    }

    @Test("− removes the last row, typed or automatic, and the other rows keep their ids and text (E6)")
    func decrementRemovesLastRow() {
        let vm = defaults.makeViewModel()
        vm.splitMode = .custom
        vm.splitCount = 4
        vm.personSplits[0].amountText = "150"
        vm.personSplits[2].amountText = "300"
        let rows = vm.personSplits

        vm.decrementSplit() // Person 4, automatic
        #expect(vm.personSplits == Array(rows.prefix(3)))

        vm.decrementSplit() // Person 3, with its typed amount
        #expect(vm.personSplits == Array(rows.prefix(2)))
        #expect(vm.splitCount == 2)
    }

    @Test("In Equal mode, + and − change the same hidden rows, and − discards the last typed amount (E8)")
    func equalModeChangesTheSameRows() {
        let vm = defaults.makeViewModel()
        vm.splitCount = 3
        vm.splitMode = .custom
        vm.personSplits[0].amountText = "100"
        vm.personSplits[2].amountText = "50"
        vm.splitMode = .equal

        vm.decrementSplit()
        #expect(vm.personSplits.map(\.amountText) == ["100", ""])
        vm.incrementSplit()
        #expect(vm.personSplits.map(\.amountText) == ["100", "", ""]) // Person 3 comes back empty

        vm.splitMode = .custom
        #expect(vm.personSplits.map(\.amountText) == ["100", "", ""])
        #expect(vm.personSplits.map(\.personNumber) == [1, 2, 3])
    }

    @Test("+ and − keep one row per person, numbered in order, and stop at 20 and 1, in either mode", arguments: [
        SplitMode.equal, .custom,
    ])
    func stepperKeepsRowsNumbered(mode: SplitMode) {
        let vm = defaults.makeViewModel()
        vm.splitMode = mode
        for _ in 1...21 {
            vm.incrementSplit()
            #expect(vm.personSplits.count == vm.splitCount)
            #expect(vm.personSplits.map(\.personNumber) == Array(1...vm.splitCount))
        }
        #expect(vm.splitCount == 20)
        let firstRow = vm.personSplits[0]

        for _ in 1...21 {
            vm.decrementSplit()
            #expect(vm.personSplits.count == vm.splitCount)
            #expect(vm.personSplits.map(\.personNumber) == Array(1...vm.splitCount))
        }
        #expect(vm.splitCount == 1)
        #expect(vm.personSplits == [firstRow])
    }
}

// MARK: - Bill Portions

@Suite("CalculatorViewModel — Custom Split Bill Portions")
struct BillPortionTests {
    private let defaults = TestDefaults()

    /// A view model with `bill`, `people` rows, and `texts` typed into the first rows. The other
    /// rows stay empty, so they're automatic.
    private func makeViewModel(bill: String, people: Int, texts: [String] = []) -> CalculatorViewModel {
        let vm = defaults.makeViewModel()
        vm.billAmountText = bill
        vm.splitCount = people
        for (index, text) in texts.enumerated() {
            vm.personSplits[index].amountText = text
        }
        return vm
    }

    /// Every row's automatic amount text, in row order.
    private func automaticAmountTexts(_ vm: CalculatorViewModel) -> [String] {
        vm.personSplits.map { vm.automaticAmountText(for: $0) }
    }

    @Test("Switching to Custom writes no text: bill 100 with 3 people splits 33,34 · 33,33 · 33,33")
    func switchingToCustomWritesNoText() {
        let vm = makeViewModel(bill: "100", people: 3)
        vm.splitMode = .custom
        #expect(vm.billPortionsMinorUnits == [3_334, 3_333, 3_333])
        #expect(automaticAmountTexts(vm) == ["33,34", "33,33", "33,33"])
        #expect(vm.personSplits.allSatisfy { $0.amountText.isEmpty })
    }

    @Test("Bill 3000 with 2 people: each row previews 1 500,00 in NOK and 1,500.00 in USD and KES")
    func twoPeople() {
        let vm = makeViewModel(bill: "3000", people: 2)
        #expect(vm.billPortionsMinorUnits == [150_000, 150_000])
        #expect(automaticAmountTexts(vm) == ["1\u{00A0}500,00", "1\u{00A0}500,00"])

        for currency in [Currency.usd, .kes] {
            vm.selectedCurrency = currency
            #expect(vm.billPortionsMinorUnits == [150_000, 150_000])
            #expect(automaticAmountTexts(vm) == ["1,500.00", "1,500.00"])
        }
        #expect(vm.personSplits.allSatisfy { $0.amountText.isEmpty })
    }

    @Test("Bill 1250 with Person 1 at 150: the automatic rows split the rest, the leftover øre first")
    func typedAndAutomaticRows() {
        let vm = makeViewModel(bill: "1250", people: 4, texts: ["150"])
        #expect(vm.billPortionsMinorUnits == [15_000, 36_667, 36_667, 36_666])
        #expect(Array(automaticAmountTexts(vm).dropFirst()) == ["366,67", "366,67", "366,66"])
        #expect(vm.personSplits.map(\.amountText) == ["150", "", "", ""])
    }

    @Test("+ re-splits the automatic rows: 4 rows at 312,50 become 5 rows at 250,00 (spec §3.1a)")
    func incrementResplits() {
        let vm = makeViewModel(bill: "1250", people: 4)
        vm.splitMode = .custom
        #expect(vm.billPortionsMinorUnits == [31_250, 31_250, 31_250, 31_250])
        vm.incrementSplit()
        #expect(vm.billPortionsMinorUnits == [25_000, 25_000, 25_000, 25_000, 25_000])
        #expect(vm.personSplits.allSatisfy { $0.amountText.isEmpty })
    }

    @Test("Typed rows over the bill leave every automatic row at 0 (E3)")
    func typedRowsOverBill() {
        let vm = makeViewModel(bill: "100", people: 4, texts: ["80", "", "50"])
        #expect(vm.billPortionsMinorUnits == [8_000, 0, 5_000, 0])
        #expect(automaticAmountTexts(vm)[1] == "0,00")
    }

    @Test("Typed rows that use the whole bill leave the automatic rows at 0")
    func typedRowsUseWholeBill() {
        let vm = makeViewModel(bill: "100", people: 3, texts: ["60", "", "40"])
        #expect(vm.billPortionsMinorUnits == [6_000, 0, 4_000])
    }

    @Test("With no readable bill, every automatic row is 0, and a typed row keeps its amount (E1, E1b)", arguments: [
        "", "0", "abc", "1 234,50", "10000000000000,01",
    ])
    func noBill(bill: String) {
        let vm = makeViewModel(bill: bill, people: 3)
        #expect(vm.billPortionsMinorUnits == [0, 0, 0])
        #expect(automaticAmountTexts(vm) == ["0,00", "0,00", "0,00"])

        vm.personSplits[1].amountText = "25"
        #expect(vm.billPortionsMinorUnits == [0, 2_500, 0])
    }

    @Test("Text that's only whitespace is automatic, and it stays as typed")
    func whitespaceIsAutomatic() {
        let vm = makeViewModel(bill: "100", people: 3, texts: ["  ", "\t", "40"])
        #expect(vm.billPortionsMinorUnits == [3_000, 3_000, 4_000])
        #expect(vm.personSplits.map(\.amountText) == ["  ", "\t", "40"])
    }

    @Test("A typed row the parser rejects counts as 0, and the automatic rows split the whole bill (spec §3.2)", arguments: [
        "abc", "1,2,3", "-5", " 5 ", "10000000000000,01",
    ])
    func rejectedRowCountsAsZero(text: String) {
        let vm = makeViewModel(bill: "100", people: 3, texts: [text])
        #expect(vm.billPortionsMinorUnits == [0, 5_000, 5_000])
        #expect(vm.personSplits[0].amountText == text)
    }

    @Test("A typed 0 is typed, not automatic: that person pays nothing (E15)")
    func typedZero() {
        let vm = makeViewModel(bill: "100", people: 2, texts: ["0"])
        #expect(vm.billPortionsMinorUnits == [0, 10_000])
    }

    @Test("With every row typed, the portions are the typed amounts, even when they don't add up")
    func everyRowTyped() {
        let vm = makeViewModel(bill: "100", people: 3, texts: ["12,50", "7.50", "30"])
        #expect(vm.billPortionsMinorUnits == [1_250, 750, 3_000])
    }

    @Test(
        "Rows add up to the bill exactly when the typed rows fit, with the leftover units on the lowest-numbered automatic rows",
        arguments: 1...20, ["0,01", "100", "1250", "9999999999999,99"]
    )
    func rowsAddUpToBill(people: Int, bill: String) throws {
        let vm = makeViewModel(bill: bill, people: people)
        let portions = vm.billPortionsMinorUnits
        #expect(portions.count == people)
        #expect(portions.reduce(0, +) == vm.billMinorUnits)
        #expect(portions == portions.sorted(by: >))
        let largest = try #require(portions.max())
        let smallest = try #require(portions.min())
        #expect(largest - smallest <= 1)

        // Person 1 types a cent: the automatic rows split the rest, and the rows still add up.
        guard people > 1 else { return }
        vm.personSplits[0].amountText = "0,01"
        let withTypedRow = vm.billPortionsMinorUnits
        let automaticPortions = Array(withTypedRow.dropFirst())
        #expect(withTypedRow.first == 1)
        #expect(withTypedRow.reduce(0, +) == vm.billMinorUnits)
        #expect(automaticPortions == automaticPortions.sorted(by: >))
    }

    @Test("Rows at the input cap add up without overflowing")
    func rowsAtCap() {
        let cap = "10000000000000"
        let vm = makeViewModel(bill: cap, people: 20, texts: Array(repeating: cap, count: 19))
        #expect(vm.billPortionsMinorUnits == Array(repeating: AmountParser.maxMinorUnits, count: 19) + [0])
        vm.personSplits[19].amountText = cap
        #expect(vm.billPortionsMinorUnits.reduce(0, +) == 20 * AmountParser.maxMinorUnits)
    }

    @Test("Untouched rows follow the bill and the head count, and typed text never changes (spec §3.1b)")
    func automaticRowsFollowChanges() {
        let vm = makeViewModel(bill: "100", people: 3, texts: ["", "40"])
        vm.splitMode = .custom
        #expect(vm.billPortionsMinorUnits == [3_000, 4_000, 3_000])

        vm.billAmountText = "160"
        #expect(vm.billPortionsMinorUnits == [6_000, 4_000, 6_000])

        vm.incrementSplit()
        #expect(vm.billPortionsMinorUnits == [4_000, 4_000, 4_000, 4_000])

        vm.decrementSplit()
        vm.decrementSplit()
        #expect(vm.billPortionsMinorUnits == [12_000, 4_000])
        #expect(vm.personSplits.map(\.amountText) == ["", "40"])
    }

    @Test("Bill, tip, rounding, currency, and mode changes keep every row's id and text (E11)")
    func otherInputsKeepRows() {
        let vm = makeViewModel(bill: "100", people: 3, texts: ["12,50", "", "abc"])
        vm.splitMode = .custom
        let rows = vm.personSplits

        vm.billAmountText = "250"
        vm.selectedPreset = .custom
        vm.customTipPercent = 33
        for rounding in RoundingMode.allCases {
            vm.selectedRounding = rounding
        }
        for currency in Currency.allCases {
            vm.selectedCurrency = currency
        }
        vm.splitMode = .equal
        vm.savePreferences()
        vm.splitMode = .custom

        #expect(vm.personSplits == rows)
    }

    @Test("Equal → Custom → type → Equal → Custom keeps the typed text")
    func modeRoundTripKeepsTypedText() {
        let vm = makeViewModel(bill: "1250", people: 4)
        vm.splitMode = .custom
        vm.personSplits[0].amountText = "150"
        vm.splitMode = .equal
        vm.splitMode = .custom
        #expect(vm.personSplits.map(\.amountText) == ["150", "", "", ""])
        #expect(vm.billPortionsMinorUnits == [15_000, 36_667, 36_667, 36_666])
    }

    @Test("A row that isn't in the list previews 0")
    func rowNotInList() {
        let vm = makeViewModel(bill: "100", people: 2)
        #expect(vm.automaticAmountText(for: PersonSplit(personNumber: 1)) == "0,00")
    }
}
