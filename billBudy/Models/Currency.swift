import Foundation

enum Currency: String, CaseIterable, Identifiable {
    case nok, usd, kes

    var id: Self { self }

    var symbol: String {
        switch self {
        case .nok: "kr"
        case .usd: "$"
        case .kes: "KSh"
        }
    }

    var flag: String {
        switch self {
        case .nok: "\u{1F1F3}\u{1F1F4}"
        case .usd: "\u{1F1FA}\u{1F1F8}"
        case .kes: "\u{1F1F0}\u{1F1EA}"
        }
    }

    var locale: String {
        switch self {
        case .nok: "nb_NO"
        case .usd: "en_US"
        case .kes: "en_KE"
        }
    }

    /// Digits after the decimal separator: one unit is 10^fractionDigits minor units (øre, cents).
    /// The single source of the minor-unit scale.
    var fractionDigits: Int {
        switch self {
        case .nok, .usd, .kes: 2
        }
    }

    /// `minorUnits` in whole units of this currency, for display: 42_167 øre → 421.67.
    ///
    /// The one minor-units → `Double` conversion: every amount the app computes in minor units
    /// becomes a `Double` here, and nowhere else.
    func amount(minorUnits: Int) -> Double {
        Self.amount(minorUnits: minorUnits, fractionDigits: fractionDigits)
    }

    /// `minorUnits` divided by 10^`fractionDigits`: the scale behind `amount(minorUnits:)`,
    /// testable at scales no currency uses yet. A negative `fractionDigits` counts as 0.
    ///
    /// Exact within two bounds: up to 2^53 minor units, and `fractionDigits` ≤ 22. Inside them,
    /// both operands are exact `Double`s (10^22 is the largest power of ten a `Double` holds
    /// exactly), so the division rounds once and gives the `Double` nearest the decimal amount:
    /// 42_167 at 2 digits gives the same `Double` as `421.67`.
    static func amount(minorUnits: Int, fractionDigits: Int) -> Double {
        var unit = 1.0
        for _ in 0..<max(0, fractionDigits) {
            unit *= 10
        }
        return Double(minorUnits) / unit
    }
}
