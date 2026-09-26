import SwiftUI
import Testing
import UIKit
@testable import billBudy

// Expected values come from docs/design/2A-unequal-splits.md §5. Colors are resolved for an explicit
// appearance and compared as "#RRGGBB", so a match means every sRGB channel is within half an 8-bit step.

// MARK: - Colors

@Suite("Design tokens — Colors")
struct DesignTokenColorTests {

    @Test("bbWarning is #C93400 in light and #FF9F0A in dark")
    func warning() {
        #expect(AppColors.bbWarning.hex(in: .light) == "#C93400")
        #expect(AppColors.bbWarning.hex(in: .dark) == "#FF9F0A")
    }

    @Test("bbTealText is #00695C in light and #00E5CC in dark")
    func tealText() {
        #expect(AppColors.bbTealText.hex(in: .light) == "#00695C")
        #expect(AppColors.bbTealText.hex(in: .dark) == "#00E5CC")
    }

    @Test("In dark, bbTealText matches bbTeal, so the app (forced dark) looks the same")
    func tealTextMatchesTealInDark() {
        #expect(AppColors.bbTealText.hex(in: .dark) == AppColors.bbTeal.hex(in: .dark))
    }
}

// MARK: - Typography

@Suite("Design tokens — Typography")
struct DesignTokenTypographyTests {

    @Test("amountField is the rounded medium headline with monospaced digits")
    func amountField() {
        let headline = Font.system(.headline, design: .rounded, weight: .medium)
        #expect(AppTypography.amountField == headline.monospacedDigit())
        // Font equality sees the digit modifier, so a token without it can't pass the check above.
        #expect(AppTypography.amountField != headline)
    }

    @Test("amountMinimumScale is 0.5, as a CGFloat")
    func amountMinimumScale() {
        #expect(AppTypography.amountMinimumScale == 0.5)
        #expect(type(of: AppTypography.amountMinimumScale) == CGFloat.self)
    }
}

// MARK: - Spacing

@Suite("Design tokens — Spacing")
struct DesignTokenSpacingTests {

    @Test("minTapTarget is the HIG's 44 pt, as a CGFloat")
    func minTapTarget() {
        #expect(AppSpacing.minTapTarget == 44)
        #expect(type(of: AppSpacing.minTapTarget) == CGFloat.self)
    }
}

// MARK: - AccentColor

@Suite("AccentColor asset")
struct AccentColorTests {

    @Test("Light is #00695C; dark and unspecified keep #00E5CC")
    func appearances() throws {
        let accent = try #require(UIColor(named: "AccentColor"))
        #expect(accent.hex(for: .light) == "#00695C")
        #expect(accent.hex(for: .dark) == "#00E5CC")
        #expect(accent.hex(for: .unspecified) == "#00E5CC")
    }
}

// MARK: - Helpers

private extension Color {
    /// The color as SwiftUI resolves it for a view in `scheme`, as "#RRGGBB".
    /// Not `UIColor(self)`: on iOS 17.5 that loses the adaptive provider, so dark resolves to the light value.
    func hex(in scheme: ColorScheme) -> String {
        var environment = EnvironmentValues()
        environment.colorScheme = scheme
        let resolved = resolve(in: environment)
        return hexString(
            red: Double(resolved.red), green: Double(resolved.green),
            blue: Double(resolved.blue), alpha: Double(resolved.opacity)
        )
    }
}

private extension UIColor {
    /// The color resolved for `style`, as "#RRGGBB".
    func hex(for style: UIUserInterfaceStyle) -> String {
        let resolved = resolvedColor(with: UITraitCollection(userInterfaceStyle: style))
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        guard resolved.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else { return "not RGB" }
        return hexString(red: red, green: green, blue: blue, alpha: alpha)
    }
}

/// sRGB channels in 0...1 as "#RRGGBB", each rounded to the nearest 8-bit step. A color that isn't opaque
/// gets its alpha appended, so it can't match a plain "#RRGGBB".
private func hexString(red: Double, green: Double, blue: Double, alpha: Double) -> String {
    func byte(_ channel: Double) -> Int { Int((channel * 255).rounded()) }
    let hex = String(format: "#%02lX%02lX%02lX", byte(red), byte(green), byte(blue))
    return byte(alpha) == 255 ? hex : "\(hex), alpha \(byte(alpha))/255"
}
