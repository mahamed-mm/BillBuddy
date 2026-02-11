import Foundation

extension Double {
    func formatted(as currency: Currency) -> String {
        CurrencyFormatter.format(amount: self, currency: currency)
    }
}
