import Foundation

enum CurrencyFormatter {
    private static var cache: [String: NumberFormatter] = [:]

    static func format(amount: Double, currency: Currency) -> String {
        let formatter = formatter(for: currency)
        return formatter.string(from: NSNumber(value: amount)) ?? "\(currency.symbol) \(amount)"
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
}
