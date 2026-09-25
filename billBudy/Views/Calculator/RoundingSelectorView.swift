import SwiftUI

struct RoundingSelectorView: View {
    @Environment(CalculatorViewModel.self) private var viewModel
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Rounding")
                .font(AppTypography.headline)
                .foregroundStyle(AppColors.bbPrimaryText)

            LazyVGrid(columns: columns, spacing: AppSpacing.sm) {
                ForEach(RoundingMode.allCases) { mode in
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

    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: AppSpacing.sm),
            count: Self.columnCount(for: dynamicTypeSize)
        )
    }

    /// Four pills don't fit in one row on a 6.1" screen, so they wrap into a grid instead of
    /// scrolling out of view. Accessibility sizes use one full-width pill per row.
    static func columnCount(for dynamicTypeSize: DynamicTypeSize) -> Int {
        dynamicTypeSize.isAccessibilitySize ? 1 : 2
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
                .contentShape(Capsule())
                .background(isSelected ? AppColors.bbSelectedChip : .clear)
                .clipShape(Capsule())
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
