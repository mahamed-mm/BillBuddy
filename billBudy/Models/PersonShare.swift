import Foundation

/// What one person pays in a custom split (output), in exact minor units (øre, cents) of `currency`.
///
/// Shares are rebuilt whenever the split changes, so a share's id is its person number, which
/// stays the same from one rebuild to the next.
struct PersonShare: Identifiable, Equatable {
    /// 1-based, the same as the person's `PersonSplit.personNumber`.
    let personNumber: Int

    /// The person's part of the bill before tip, typed or automatic, in minor units.
    let billPortionMinorUnits: Int

    /// What the person pays in minor units: the bill portion plus their part of the tip and rounding.
    let shareMinorUnits: Int

    /// The currency of both amounts. Its `fractionDigits` sets their scale, so the `Double`
    /// accessors can't use the wrong one.
    let currency: Currency

    var id: Int { personNumber }

    /// "Person N", as on the person's row.
    var label: String { PersonSplit.label(personNumber: personNumber) }

    /// `billPortionMinorUnits` in whole units of `currency`, for display: 36_667 øre → 366.67.
    var billPortionAmount: Double {
        Self.amount(minorUnits: billPortionMinorUnits, fractionDigits: currency.fractionDigits)
    }

    /// `shareMinorUnits` in whole units of `currency`, for display: 42_167 øre → 421.67.
    var shareAmount: Double {
        Self.amount(minorUnits: shareMinorUnits, fractionDigits: currency.fractionDigits)
    }

    /// `minorUnits` divided by 10^`fractionDigits`: the conversion behind the `Double` accessors,
    /// testable at scales no currency uses yet. A negative `fractionDigits` counts as 0.
    ///
    /// Up to 2^53 minor units, the result is the `Double` nearest the decimal amount (42_167 at
    /// 2 digits gives the same `Double` as `421.67`), because both operands are exact and the
    /// division rounds once.
    static func amount(minorUnits: Int, fractionDigits: Int) -> Double {
        var unit = 1.0
        for _ in 0..<max(0, fractionDigits) {
            unit *= 10
        }
        return Double(minorUnits) / unit
    }
}
