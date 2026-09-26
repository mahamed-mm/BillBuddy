import SwiftUI

struct RoundingSelectorView: View {
    @Environment(CalculatorViewModel.self) private var viewModel
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Rounding")
                .font(AppTypography.headline)
                .foregroundStyle(AppColors.bbPrimaryText)

            // Grid is eager, unlike LazyVGrid, so all four pills are in the accessibility tree
            // even when they start off screen, and VoiceOver reaches them before the results card.
            Grid(horizontalSpacing: AppSpacing.sm, verticalSpacing: AppSpacing.sm) {
                ForEach(Self.rows(columnCount: Self.columnCount(for: dynamicTypeSize)), id: \.self) { row in
                    GridRow {
                        ForEach(row) { mode in
                            RoundingPill(
                                title: mode.displayText,
                                isSelected: viewModel.selectedRounding == mode
                            ) {
                                HapticManager.lightImpact()
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    viewModel.selectedRounding = mode
                                }
                                viewModel.savePreferences()
                            }
                        }
                    }
                }
            }
        }
    }

    /// Four pills don't fit in one row on a 6.1" screen, so they wrap into a grid instead of
    /// scrolling out of view. Accessibility sizes use one full-width pill per row.
    static func columnCount(for dynamicTypeSize: DynamicTypeSize) -> Int {
        dynamicTypeSize.isAccessibilitySize ? 1 : 2
    }

    /// The rounding modes in display order, split into grid rows of `columnCount` pills.
    static func rows(columnCount: Int) -> [[RoundingMode]] {
        let modes = RoundingMode.allCases
        let width = max(columnCount, 1)
        return stride(from: 0, to: modes.count, by: width).map { start in
            Array(modes[start..<min(start + width, modes.count)])
        }
    }
}

private struct RoundingPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTypography.body)
                .foregroundStyle(isSelected ? AppColors.bbTeal : AppColors.bbPrimaryText)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
                .background(isSelected ? AppColors.bbSelectedChip : .clear)
                .clipShape(Capsule())
                // An unselected pill has a clear fill, which doesn't take taps, so only its label and
                // stroke would respond. Placed after the padding, this makes the whole capsule tappable.
                .contentShape(Capsule())
                .overlay(
                    Capsule()
                        .strokeBorder(
                            isSelected ? AppColors.bbSelectedBorder : AppColors.bbUnselectedBorder,
                            lineWidth: 1.5
                        )
                )
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(title) rounding")
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
    }
}

#Preview("Dark") {
    RoundingSelectorView()
        .padding(AppSpacing.md)
        .background(AppColors.bbBackground)
        .environment(CalculatorViewModel())
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    RoundingSelectorView()
        .padding(AppSpacing.md)
        .background(AppColors.bbBackground)
        .environment(CalculatorViewModel())
        .preferredColorScheme(.light)
}

#Preview("Dark, AX5") {
    RoundingSelectorView()
        .padding(AppSpacing.md)
        .background(AppColors.bbBackground)
        .environment(CalculatorViewModel())
        .preferredColorScheme(.dark)
        .dynamicTypeSize(.accessibility5)
}
