import SwiftUI

struct RoundingSelectorView: View {
    @Environment(CalculatorViewModel.self) private var viewModel

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Rounding")
                .font(AppTypography.headline)
                .foregroundStyle(AppColors.bbPrimaryText)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.sm) {
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
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
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

#Preview {
    RoundingSelectorView()
        .padding()
        .environment(CalculatorViewModel())
}
