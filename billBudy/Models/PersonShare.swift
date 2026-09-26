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
    var billPortionAmount: Double { currency.amount(minorUnits: billPortionMinorUnits) }

    /// `shareMinorUnits` in whole units of `currency`, for display: 42_167 øre → 421.67.
    var shareAmount: Double { currency.amount(minorUnits: shareMinorUnits) }
}
