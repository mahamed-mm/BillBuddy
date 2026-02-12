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
}
