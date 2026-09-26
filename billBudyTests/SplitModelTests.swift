import Foundation
import Testing
@testable import billBudy

// MARK: - SplitMode

@Suite("SplitMode")
struct SplitModeTests {

    @Test("All cases exist (2 total), Equal first, as the toggle shows them")
    func allCases() {
        #expect(SplitMode.allCases.count == 2)
        #expect(SplitMode.allCases == [.equal, .custom])
    }

    @Test("Raw values")
    func rawValues() {
        #expect(SplitMode.equal.rawValue == 0)
        #expect(SplitMode.custom.rawValue == 1)
        #expect(SplitMode(rawValue: 0) == .equal)
        #expect(SplitMode(rawValue: 1) == .custom)
        #expect(SplitMode(rawValue: 2) == nil)
    }

    @Test("Display text values")
    func displayText() {
        #expect(SplitMode.equal.displayText == "Equal")
        #expect(SplitMode.custom.displayText == "Custom")
    }

    @Test("Each mode is its own id")
    func ids() {
        #expect(SplitMode.allCases.map(\.id) == SplitMode.allCases)
    }
}

// MARK: - PersonSplit

@Suite("PersonSplit")
struct PersonSplitTests {

    @Test("A new row has its person number and empty text, so it's automatic")
    func newRow() {
        let split = PersonSplit(personNumber: 1)
        #expect(split.personNumber == 1)
        #expect(split.amountText.isEmpty)
        #expect(split.isAutomatic)
    }

    @Test("Labels are \"Person N\", 1-based", arguments: [(1, "Person 1"), (2, "Person 2"), (20, "Person 20")])
    func label(personNumber: Int, expected: String) {
        #expect(PersonSplit(personNumber: personNumber).label == expected)
        #expect(PersonSplit.label(personNumber: personNumber) == expected)
    }

    @Test("The id stays the same while the text changes")
    func idIsStable() {
        var split = PersonSplit(personNumber: 3)
        let id = split.id
        split.amountText = "12,50"
        #expect(split.id == id)
        split.amountText = ""
        #expect(split.id == id)
    }

    @Test("Every row gets its own id, not its index or person number")
    func idsAreUnique() {
        let rows = (1...20).map { PersonSplit(personNumber: $0) }
        #expect(Set(rows.map(\.id)).count == rows.count)
        // After − then +, the new Person 2 has a new id, so focus or scroll state keyed by the
        // removed row's id can't land on it.
        #expect(PersonSplit(personNumber: 2).id != PersonSplit(personNumber: 2).id)
    }

    @Test("Text that's empty after trimming whitespace is automatic", arguments: [
        "", " ", "  ", "\t", "\n", "\u{00A0}", " \t\n\u{00A0} ",
    ])
    func automaticText(text: String) {
        #expect(PersonSplit.isAutomatic(text))
        #expect(PersonSplit(personNumber: 1, amountText: text).isAutomatic)
    }

    @Test("Any other text is typed, even text AmountParser rejects", arguments: [
        "0", // E15: a typed 0 means that person pays nothing; it doesn't split the rest
        "12,50", "abc",
        "12.50", "0,00", ",", " 5 ", "1,2,3",
    ])
    func typedText(text: String) {
        #expect(!PersonSplit.isAutomatic(text))
        #expect(!PersonSplit(personNumber: 1, amountText: text).isAutomatic)
    }

    @Test("Emptying a typed row makes it automatic again")
    func emptyingMakesAutomatic() {
        var split = PersonSplit(personNumber: 2, amountText: "150")
        #expect(!split.isAutomatic)
        split.amountText = ""
        #expect(split.isAutomatic)
    }
}

// MARK: - PersonShare

@Suite("PersonShare")
struct PersonShareTests {

    @Test("Holds the person number and both amounts in minor units, each with its own Double accessor")
    func holdsMinorUnits() {
        let share = PersonShare(personNumber: 2, billPortionMinorUnits: 36_667, shareMinorUnits: 42_167, currency: .nok)
        #expect(share.personNumber == 2)
        #expect(share.billPortionMinorUnits == 36_667)
        #expect(share.shareMinorUnits == 42_167)
        #expect(share.currency == .nok)
        #expect(share.billPortionAmount == 366.67)
        #expect(share.shareAmount == 421.67)
    }

    @Test("The id and label come from the person number")
    func idAndLabel() {
        let share = PersonShare(personNumber: 4, billPortionMinorUnits: 0, shareMinorUnits: 0, currency: .usd)
        #expect(share.id == 4)
        #expect(share.label == "Person 4")
    }

    @Test("Double accessors give the amount in whole units in every currency", arguments: [
        (0, 0.0), (1, 0.01), (29, 0.29), (17_250, 172.5), (42_167, 421.67),
        (99_999_999, 999_999.99), (1_000_000_000_000_000, 10_000_000_000_000.0),
    ])
    func doubleAccessors(minorUnits: Int, expected: Double) {
        for currency in Currency.allCases {
            let share = PersonShare(
                personNumber: 1, billPortionMinorUnits: minorUnits, shareMinorUnits: minorUnits, currency: currency
            )
            #expect(share.billPortionAmount == expected)
            #expect(share.shareAmount == expected)
        }
    }

    @Test("The scale comes from Currency.fractionDigits")
    func scaleFromFractionDigits() {
        for currency in Currency.allCases {
            let share = PersonShare(
                personNumber: 1, billPortionMinorUnits: 1_234, shareMinorUnits: 1_234, currency: currency
            )
            let expected = PersonShare.amount(minorUnits: 1_234, fractionDigits: currency.fractionDigits)
            #expect(share.billPortionAmount == expected)
            #expect(share.shareAmount == expected)
        }
        #expect(PersonShare.amount(minorUnits: 1_234, fractionDigits: 0) == 1_234.0)
        #expect(PersonShare.amount(minorUnits: 1_234, fractionDigits: 1) == 123.4)
        #expect(PersonShare.amount(minorUnits: 1_234, fractionDigits: 3) == 1.234)
        #expect(PersonShare.amount(minorUnits: 5, fractionDigits: 3) == 0.005)
    }

    @Test("A negative scale counts as 0")
    func negativeScale() {
        #expect(PersonShare.amount(minorUnits: 1_234, fractionDigits: -1) == 1_234.0)
    }
}
