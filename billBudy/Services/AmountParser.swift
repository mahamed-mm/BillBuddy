import Foundation

/// Parses amounts the user types, with the same result on every device region.
///
/// A valid amount is ASCII digits with at most one decimal separator, either "," or ".",
/// so the decimal pad works in comma-decimal regions such as Norway. It needs at least one
/// digit, and either side of the separator may be empty ("12," and ",5" are valid).
/// Everything else is rejected: whitespace, signs, grouping ("1.234,50"), exponents,
/// "nan", and "inf". No `NumberFormatter` is involved, because its result depends on
/// the device locale.
///
/// Amounts above `maxMinorUnits` are rejected too. Every function here applies that cap, so
/// nothing can decide validity without it. The app reads every amount through
/// `minorUnits(from:currency:)`.
enum AmountParser {
    /// The largest amount `minorUnits(from:currency:)` accepts: 10^15 minor units
    /// (10 000 000 000 000,00 kr). Anything above it is rejected like any other invalid text.
    ///
    /// Up to it, the tip (at most 50 %), the total, 20 rounded-up shares, and the sum of 20 rows
    /// all fit in `Int` with room to spare, and the bill, tip, and total stay under 2^53 minor
    /// units, where `Currency.amount(minorUnits:)` is exact.
    static let maxMinorUnits = 1_000_000_000_000_000

    /// The amount in `text` as minor units of `currency` (øre, cents), rounded half-up at
    /// `currency.fractionDigits`, or `nil` if `text` isn't a valid amount or is above
    /// `maxMinorUnits`.
    ///
    /// Built from the digits with no `Double` step, so it's exact:
    /// `"12,50"` → 1250, `"0.29"` → 29, `"1.005"` → 101,
    /// `"10000000000000"` → 1_000_000_000_000_000, `"10000000000000,01"` → `nil`.
    static func minorUnits(from text: String, currency: Currency) -> Int? {
        minorUnits(from: text, fractionDigits: currency.fractionDigits)
    }

    /// The amount in `text` as minor units at `fractionDigits` digits: the scale behind
    /// `minorUnits(from:currency:)`, testable at scales no currency uses yet. A negative
    /// `fractionDigits` counts as 0. The cap is the same at every scale: `maxMinorUnits`.
    static func minorUnits(from text: String, fractionDigits: Int) -> Int? {
        guard let parts = decimalParts(of: text) else { return nil }
        let scale = max(0, fractionDigits)
        let kept = parts.fraction.prefix(scale)
        let digits = String(parts.integer) + String(kept) + String(repeating: "0", count: scale - kept.count)
        // The cut-off digits are worth at least half a minor unit exactly when the first is 5 or more.
        let roundsUp = parts.fraction.dropFirst(scale).first.map { $0 >= "5" } ?? false
        // `digits` is validated, so `Int(_:)` fails only when the amount is far above the cap.
        guard let truncated = digits.isEmpty ? 0 : Int(digits), truncated <= maxMinorUnits else { return nil }
        // At most `maxMinorUnits` + 1, so the addition can't overflow.
        let units = truncated + (roundsUp ? 1 : 0)
        return units <= maxMinorUnits ? units : nil
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
