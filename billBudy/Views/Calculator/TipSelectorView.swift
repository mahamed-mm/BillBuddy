import SwiftUI

struct TipSelectorView: View {
    @Environment(CalculatorViewModel.self) private var viewModel

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        @Bindable var viewModel = viewModel

        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Tip percentage")
                .font(AppTypography.headline)
                .foregroundStyle(AppColors.bbPrimaryText)

            LazyVGrid(columns: columns, spacing: AppSpacing.sm) {
                ForEach(TipPreset.allCases) { preset in
                    TipPresetButton(
                        preset: preset,
                        isSelected: viewModel.selectedPreset == preset
                    ) {
                        HapticManager.lightImpact()
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            viewModel.selectedPreset = preset
                        }
                        viewModel.savePreferences()
                    }
                }
            }

            if viewModel.selectedPreset == .custom {
                VStack(spacing: AppSpacing.xs) {
                    Slider(value: $viewModel.customTipPercent, in: 0...50, step: 1)
                        .tint(AppColors.bbTeal)
                        .onChange(of: viewModel.customTipPercent) {
                            viewModel.savePreferences()
                        }

                    Text("\(Int(viewModel.customTipPercent))%")
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.bbSecondaryText)
                }
                .padding(.top, AppSpacing.xs)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: viewModel.selectedPreset)
    }
}

#Preview {
    TipSelectorView()
        .padding()
        .environment(CalculatorViewModel())
}
