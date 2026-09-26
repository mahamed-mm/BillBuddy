import SwiftUI

enum AppTypography {
    static let largeTitle: Font = .system(.largeTitle, design: .rounded, weight: .bold)
    static let title: Font = .system(.title2, design: .rounded, weight: .semibold)
    static let headline: Font = .system(.headline, design: .rounded, weight: .medium)
    static let body: Font = .system(.body, design: .rounded)
    static let caption: Font = .system(.caption, design: .rounded)
    static let mono: Font = .system(.title, design: .monospaced, weight: .bold)
    static let amountField: Font = .system(.headline, design: .rounded, weight: .medium).monospacedDigit()

    /// The `minimumScaleFactor` for one-line amounts, so they shrink instead of wrapping mid-number.
    static let amountMinimumScale: CGFloat = 0.5
}
