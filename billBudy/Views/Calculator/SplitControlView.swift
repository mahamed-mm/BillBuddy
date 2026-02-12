import SwiftUI

struct SplitControlView: View {
    @Environment(CalculatorViewModel.self) private var viewModel

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Split the bill")
                .font(AppTypography.headline)
                .foregroundStyle(AppColors.bbPrimaryText)

            HStack {
                Button {
                    HapticManager.mediumImpact()
                    viewModel.decrementSplit()
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(AppTypography.title)
                        .foregroundStyle(viewModel.splitCount <= 1 ? AppColors.bbSecondaryText : AppColors.bbTeal)
                }
                .disabled(viewModel.splitCount <= 1)
                .accessibilityLabel("Decrease split")
                .accessibilityValue("\(viewModel.splitCount) people")

                Text("\(viewModel.splitCount)")
                    .font(AppTypography.title)
                    .foregroundStyle(AppColors.bbPrimaryText)
                    .frame(minWidth: 44)
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: viewModel.splitCount)

                Button {
                    HapticManager.mediumImpact()
                    viewModel.incrementSplit()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(AppTypography.title)
                        .foregroundStyle(viewModel.splitCount >= 20 ? AppColors.bbSecondaryText : AppColors.bbTeal)
                }
                .disabled(viewModel.splitCount >= 20)
                .accessibilityLabel("Increase split")
                .accessibilityValue("\(viewModel.splitCount) people")
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    SplitControlView()
        .padding()
        .environment(CalculatorViewModel())
}
