import Foundation

/// Parses amounts the user types, with the same result on every device region.
///
/// A valid amount is ASCII digits with at most one decimal separator, either "," or ".",
/// so the decimal pad works in comma-decimal regions such as Norway. It needs at least one
/// digit, and either side of the separator may be empty ("12," and ",5" are valid).
/// Everything else is rejected: whitespace, signs, grouping ("1.234,50"), exponents,
/// "nan", and "inf". No `NumberFormatter` is involved, because its result depends on
/// the device locale.
enum AmountParser {
    /// The amount in `text` with every typed digit kept, or `nil` if `text` isn't a valid amount.
    ///
    /// `"12,50"` and `"12.50"` → 12.5, `",5"` → 0.5, `"1e5"` → `nil`.
    static func amount(from text: String) -> Double? {
        guard let parts = decimalParts(of: text) else { return nil }
        let integer = parts.integer.isEmpty ? "0" : parts.integer
        let fraction = parts.fraction.isEmpty ? "0" : parts.fraction
        // Only ASCII digits are left, so `Double(_:)` does a plain, locale-independent parse.
        guard let value = Double("\(integer).\(fraction)"), value.isFinite else { return nil }
        return value
    }

    /// The amount in `text` as minor units of `currency` (øre, cents), rounded half-up at
    /// `currency.fractionDigits`, or `nil` if `text` isn't a valid amount or doesn't fit in `Int`.
    ///
    /// Built from the digits with no `Double` step, so it's exact:
    /// `"12,50"` → 1250, `"0.29"` → 29, `"1.005"` → 101.
    static func minorUnits(from text: String, currency: Currency) -> Int? {
        guard let parts = decimalParts(of: text) else { return nil }
        let scale = currency.fractionDigits
        let kept = parts.fraction.prefix(scale)
        let digits = String(parts.integer) + String(kept) + String(repeating: "0", count: scale - kept.count)
        // The cut-off digits are worth at least half a minor unit exactly when the first is 5 or more.
        let roundsUp = parts.fraction.dropFirst(scale).first.map { $0 >= "5" } ?? false
        // `digits` is validated, so `Int(_:)` fails only when the amount is too large.
        guard let truncated = digits.isEmpty ? 0 : Int(digits) else { return nil }
        let (units, overflow) = truncated.addingReportingOverflow(roundsUp ? 1 : 0)
        return overflow ? nil : units
    }

    /// The digits before and after the decimal separator, or `nil` if `text` isn't a valid amount.
    private static func decimalParts(of text: String) -> (integer: Substring, fraction: Substring)? {
        let parts = text.split(omittingEmptySubsequences: false) { $0 == "," || $0 == "." }
        guard parts.count <= 2 else { return nil }
        let integer = parts.first ?? ""
        let fraction = parts.count == 2 ? parts[1] : ""
        guard !(integer.isEmpty && fraction.isEmpty), isDigits(integer), isDigits(fraction) else { return nil }
        return (integer, fraction)
    }

    private static func isDigits(_ text: Substring) -> Bool {
        text.unicodeScalars.allSatisfy { ("0"..."9").contains($0) }
    }
}
