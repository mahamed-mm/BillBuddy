import Testing
@testable import billBudy

@Suite("CurrencyFormatter")
struct CurrencyFormatterTests {

    @Test("USD formatting uses $ symbol")
    func usdFormatting() {
        let result = CurrencyFormatter.format(amount: 1234.5, currency: .usd)
        #expect(result.contains("$"))
        #expect(result.contains("1,234"))
    }

    @Test("NOK formatting uses Norwegian locale")
    func nokFormatting() {
        let result = CurrencyFormatter.format(amount: 1234.5, currency: .nok)
        #expect(result.contains("NOK") || result.contains("kr"))
    }

    @Test("KES formatting produces valid currency string")
    func kesFormatting() {
        let result = CurrencyFormatter.format(amount: 1234.5, currency: .kes)
        #expect(!result.isEmpty)
        #expect(result.contains("1,234"))
    }

    @Test("Zero amount formats correctly")
    func zeroAmount() {
        let result = CurrencyFormatter.format(amount: 0.0, currency: .usd)
        #expect(result.contains("$"))
        #expect(result.contains("0"))
    }

    @Test("Large amount has grouping separators")
    func largeAmount() {
        let result = CurrencyFormatter.format(amount: 1000000.0, currency: .usd)
        #expect(result.contains("1,000,000"))
    }

    @Test("Formatted string is non-empty")
    func nonEmpty() {
        let result = CurrencyFormatter.format(amount: 42.50, currency: .nok)
        #expect(!result.isEmpty)
    }

    @Test("Different currencies produce different output")
    func differentCurrencies() {
        let usd = CurrencyFormatter.format(amount: 100, currency: .usd)
        let nok = CurrencyFormatter.format(amount: 100, currency: .nok)
        let kes = CurrencyFormatter.format(amount: 100, currency: .kes)
        #expect(usd != nok)
        #expect(usd != kes)
    }

    // MARK: Without the symbol (automatic amounts, spec §3.1)

    @Test("Without the symbol, 150_000 minor units are NOK \"1 500,00\" and USD or KES \"1,500.00\"", arguments: [
        (Currency.nok, "1\u{00A0}500,00"), // nb_NO groups with a no-break space
        (.usd, "1,500.00"),
        (.kes, "1,500.00"),
    ])
    func withoutSymbol(currency: Currency, expected: String) {
        #expect(CurrencyFormatter.formatWithoutSymbol(minorUnits: 150_000, currency: currency) == expected)
    }

    @Test("Without the symbol, amounts always show 2 decimals and grouping", arguments: [
        (0, "0,00", "0.00"),
        (1, "0,01", "0.01"),
        (36_667, "366,67", "366.67"),
        (100_000, "1\u{00A0}000,00", "1,000.00"),
        (123_456_789, "1\u{00A0}234\u{00A0}567,89", "1,234,567.89"),
        (999_999_999_999_999, "9\u{00A0}999\u{00A0}999\u{00A0}999\u{00A0}999,99", "9,999,999,999,999.99"),
        (1_000_000_000_000_000, "10\u{00A0}000\u{00A0}000\u{00A0}000\u{00A0}000,00", "10,000,000,000,000.00"),
    ])
    func withoutSymbolDigits(minorUnits: Int, nok: String, usdAndKES: String) {
        #expect(CurrencyFormatter.formatWithoutSymbol(minorUnits: minorUnits, currency: .nok) == nok)
        #expect(CurrencyFormatter.formatWithoutSymbol(minorUnits: minorUnits, currency: .usd) == usdAndKES)
        #expect(CurrencyFormatter.formatWithoutSymbol(minorUnits: minorUnits, currency: .kes) == usdAndKES)
    }

    @Test(
        "Without the symbol, the number is the same as in the full format, with no symbol or letters",
        arguments: Currency.allCases, [0, 1, 36_667, 150_000, 123_456_789]
    )
    func withoutSymbolMatchesFullFormat(currency: Currency, minorUnits: Int) {
        let plain = CurrencyFormatter.formatWithoutSymbol(minorUnits: minorUnits, currency: currency)
        let full = CurrencyFormatter.format(amount: currency.amount(minorUnits: minorUnits), currency: currency)
        #expect(full.contains(plain))
        #expect(!plain.contains { $0.isLetter || $0.isCurrencySymbol })
    }
}
