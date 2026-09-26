import Testing
@testable import billBudy

// MARK: - AmountParser

@Suite("AmountParser")
struct AmountParserTests {

    @Test("Parses comma or point decimals", arguments: [
        ("12,50", 12.5), ("12.50", 12.5),
        ("12", 12.0), ("12,", 12.0), ("12.", 12.0),
        (",5", 0.5), (".5", 0.5),
        ("0", 0.0), ("0,00", 0.0), ("007", 7.0),
        ("0,29", 0.29), ("999999,99", 999999.99),
        ("1.005", 1.005), // every typed digit is kept; only minorUnits rounds
    ])
    func parsesAmount(text: String, expected: Double) {
        #expect(AmountParser.amount(from: text) == expected)
    }

    @Test("Comma and point give the same result", arguments: ["12,50", "0,29", ",5", "12,", "999999,99", "1,005"])
    func commaMatchesPoint(text: String) {
        let pointText = String(text.map { $0 == "," ? "." : $0 })
        #expect(AmountParser.amount(from: text) == AmountParser.amount(from: pointText))
        #expect(AmountParser.minorUnits(from: text, currency: .nok) == AmountParser.minorUnits(from: pointText, currency: .nok))
    }

    @Test("Rejects invalid text, including what Double(_:) accepts", arguments: [
        "", "abc", "12abc", "1,2,3", "1.234,50", "-5", "nan", "inf", "1e5",
    ])
    func rejectsInvalidText(text: String) {
        #expect(AmountParser.amount(from: text) == nil)
        #expect(AmountParser.minorUnits(from: text, currency: .nok) == nil)
    }

    @Test("Rejects bare separators, signs, whitespace, grouping, and non-ASCII digits", arguments: [
        ",", ".", ",,", "12,5.", "+5", "-0", " 12", "12 ", "1\u{00A0}234,50", "1_000",
        "0x1p3", "Infinity", "NaN", "5E3",
        "\u{0661}\u{0662}",   // Arabic-Indic "12"
        "\u{FF11}\u{FF12}",   // fullwidth "12"
        "12\u{066B}50",       // Arabic decimal separator
        "12\u{0301}",         // digit with a combining mark
    ])
    func rejectsOtherText(text: String) {
        #expect(AmountParser.amount(from: text) == nil)
        #expect(AmountParser.minorUnits(from: text, currency: .nok) == nil)
    }

    // Through Double, "0.29" * 100 is 28.999… and "1.005" * 100 is 100.499…
    @Test("Minor units come straight from the digits, rounded half-up", arguments: [
        ("12,50", 1250), ("12.50", 1250), ("0.29", 29), ("1.005", 101),
        ("12", 1200), ("12,", 1200), ("12.", 1200), (",5", 50), ("0", 0), ("0,01", 1), ("007,5", 750),
        ("0.004", 0), ("0.005", 1), ("1.00499", 100), ("0.994", 99), ("0.995", 100),
        ("9.995", 1000), ("99.9999", 10000), ("999999.99", 99_999_999),
    ])
    func minorUnits(text: String, expected: Int) {
        #expect(AmountParser.minorUnits(from: text, currency: .nok) == expected)
    }

    @Test("Minor-unit scale comes from Currency.fractionDigits")
    func minorUnitScale() {
        for currency in Currency.allCases {
            #expect(currency.fractionDigits == 2)
            #expect(AmountParser.minorUnits(from: "12,505", currency: currency) == 1251)
        }
    }

    // Int.max minor units and just above it: all far above the cap, so none of them parses.
    @Test("Minor units return nil instead of overflowing Int")
    func minorUnitsOverflow() {
        #expect(AmountParser.minorUnits(from: "92233720368547758.07", currency: .nok) == nil)
        #expect(AmountParser.minorUnits(from: "92233720368547758.074", currency: .nok) == nil)
        #expect(AmountParser.minorUnits(from: "92233720368547758.075", currency: .nok) == nil)
        #expect(AmountParser.minorUnits(from: "92233720368547758.08", currency: .nok) == nil)
    }

    @Test("The cap is 10^15 minor units: 10 000 000 000 000,00 kr")
    func capValue() {
        #expect(AmountParser.maxMinorUnits == 1_000_000_000_000_000)
    }

    @Test("Amounts up to the cap parse, including ones that round to it", arguments: [
        ("10000000000000", 1_000_000_000_000_000), ("10000000000000,00", 1_000_000_000_000_000),
        ("10000000000000.004", 1_000_000_000_000_000), // the cut-off 0,4 øre rounds down to the cap
        ("9999999999999,995", 1_000_000_000_000_000),  // half an øre rounds up to exactly the cap
        ("0010000000000000", 1_000_000_000_000_000),   // leading zeros don't count
        ("9999999999999,99", 999_999_999_999_999),
    ])
    func minorUnitsUpToCap(text: String, expected: Int) {
        for currency in Currency.allCases where currency.fractionDigits == 2 {
            #expect(AmountParser.minorUnits(from: text, currency: currency) == expected)
        }
    }

    @Test("Amounts above the cap are rejected like any invalid text", arguments: [
        "10000000000000,01", "92233720368547758,01",
        "10000000000000,005", // half an øre rounds up past the cap
        "10000000000001", "99999999999999",
    ])
    func minorUnitsAboveCap(text: String) {
        for currency in Currency.allCases where currency.fractionDigits == 2 {
            #expect(AmountParser.minorUnits(from: text, currency: currency) == nil)
        }
    }

    @Test("The fractionDigits seam rounds half-up at any scale", arguments: [
        (",5", 0, 1), ("12,49", 0, 12), ("12,5", 0, 13), ("12", 0, 12),
        ("1,0005", 3, 1_001), ("1,2344", 3, 1_234), ("1,2345", 3, 1_235), ("12", 3, 12_000), (",5", 3, 500),
        ("12,50", 2, 1_250), ("1.005", 2, 101),
        (",5", -1, 1), // a negative scale counts as 0
    ])
    func minorUnitsAtScale(text: String, fractionDigits: Int, expected: Int) {
        #expect(AmountParser.minorUnits(from: text, fractionDigits: fractionDigits) == expected)
    }

    @Test("The cap is the same number of minor units at every scale")
    func capAtEveryScale() {
        #expect(AmountParser.minorUnits(from: "1000000000000000", fractionDigits: 0) == 1_000_000_000_000_000)
        #expect(AmountParser.minorUnits(from: "1000000000000000,5", fractionDigits: 0) == nil)
        #expect(AmountParser.minorUnits(from: "1000000000000001", fractionDigits: 0) == nil)
        #expect(AmountParser.minorUnits(from: "1000000000000", fractionDigits: 3) == 1_000_000_000_000_000)
        #expect(AmountParser.minorUnits(from: "1000000000000,0005", fractionDigits: 3) == nil)
    }

    @Test("Amounts beyond Double's range return nil, not infinity")
    func amountNotFinite() {
        let huge = String(repeating: "9", count: 400)
        #expect(AmountParser.amount(from: huge) == nil)
        #expect(AmountParser.minorUnits(from: huge, currency: .nok) == nil)
    }
}

// MARK: - CalculatorViewModel Bill Parsing

@Suite("CalculatorViewModel — Bill Parsing")
struct BillParsingTests {
    private let defaults = TestDefaults()

    @Test("Comma decimal bill parses")
    func commaDecimalBill() {
        let vm = defaults.makeViewModel()
        vm.billAmountText = "12,50"
        #expect(vm.billAmount == 12.5)
    }

    @Test("Comma decimal bill drives tip, total, and per person")
    func commaDecimalResults() {
        let vm = defaults.makeViewModel()
        vm.billAmountText = "12,50"
        vm.selectedPreset = .twenty
        vm.selectedRounding = .none
        vm.splitCount = 2
        #expect(vm.tipAmount == 2.5)
        #expect(vm.totalAmount == 15.0)
        #expect(vm.perPersonAmount == 7.5)
    }

    @Test("Text that Double(_:) accepted but the parser rejects gives a zero bill", arguments: ["-5", "nan", "inf", "1e5"])
    func rejectedTextIsZero(text: String) {
        let vm = defaults.makeViewModel()
        vm.billAmountText = text
        #expect(vm.billAmount == 0.0)
        #expect(vm.totalAmount == 0.0)
    }
}
