import Foundation

/// One person's row in a custom split (input): their part of the bill before tip, as typed.
///
/// A row is *typed* or *automatic* depending only on its text; see `isAutomatic(_:)`. An automatic
/// row pays an even share of what the typed rows leave of the bill. That amount is computed and
/// never written into `amountText`, so the row keeps following the bill and the other rows.
struct PersonSplit: Identifiable, Equatable {
    /// Unique to this row for its whole life, so `ForEach` and focus follow the row while its text
    /// changes. It isn't the index or the person number, so a removed row's id never passes to the
    /// row that later takes its place.
    let id = UUID()

    /// 1-based: Person 1 is the first row. Stored, because rows are only appended or removed at the
    /// end, so a row keeps its number for its whole life.
    let personNumber: Int

    /// The text exactly as typed, never reformatted. Empty by default, so a new row is automatic.
    var amountText = ""

    /// "Person N".
    var label: String { Self.label(personNumber: personNumber) }

    /// Whether this row is automatic; see `isAutomatic(_:)`.
    var isAutomatic: Bool { Self.isAutomatic(amountText) }

    /// "Person N" for person number N, for places that have the number but not the row.
    static func label(personNumber: Int) -> String {
        "Person \(personNumber)"
    }

    /// Whether a row with `amountText` is automatic: the text is empty after trimming whitespace,
    /// line breaks included. Any other text makes the row typed, even text that `AmountParser`
    /// rejects: `""` and `"  "` are automatic; `"0"`, `"12,50"`, and `"abc"` are typed.
    ///
    /// The one definition of the rule. It takes a bare `String`, so a view that has only the text
    /// uses the same rule.
    static func isAutomatic(_ amountText: String) -> Bool {
        amountText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
