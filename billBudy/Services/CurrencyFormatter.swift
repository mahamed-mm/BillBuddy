import Foundation

enum CurrencyFormatter {
    private static var cache: [String: NumberFormatter] = [:]
    private static var numberCache: [Currency: NumberFormatter] = [:]

    static func format(amount: Double, currency: Currency) -> String {
        let formatter = formatter(for: currency)
        return formatter.string(from: NSNumber(value: amount)) ?? "\(currency.symbol) \(amount)"
    }

    /// `minorUnits` of `currency` as a number without the symbol: the format of automatic-row
    /// previews (spec §3.1). It uses the currency's locale, so it groups and separates decimals
    /// like `format(amount:currency:)`, and shows exactly `currency.fractionDigits` decimals:
    /// 150_000 → NOK "1 500,00" (grouped with a no-break space, U+00A0), USD and KES "1,500.00".
    ///
    /// For display only; it's never parsed.
    static func formatWithoutSymbol(minorUnits: Int, currency: Currency) -> String {
        let amount = currency.amount(minorUnits: minorUnits)
        return numberFormatter(for: currency).string(from: NSNumber(value: amount)) ?? "\(amount)"
    }

    private static func formatter(for currency: Currency) -> NumberFormatter {
        if let cached = cache[currency.locale] {
            return cached
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: currency.locale)
        formatter.currencyCode = currency.rawValue.uppercased()

        cache[currency.locale] = formatter
        return formatter
    }

    private static func numberFormatter(for currency: Currency) -> NumberFormatter {
        if let cached = numberCache[currency] {
            return cached
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: currency.locale)
        formatter.minimumFractionDigits = currency.fractionDigits
        formatter.maximumFractionDigits = currency.fractionDigits

        numberCache[currency] = formatter
        return formatter
    }
}
