import SwiftUI

struct CalculatorView: View {
    @Environment(CalculatorViewModel.self) private var viewModel

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: AppSpacing.lg) {
                CurrencyPickerView()
                BillInputView()
                TipSelectorView()
                SplitControlView()
                ResultsCardView()
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.xxl)
        }
        .background(AppColors.bbBackground)
    }
}

#Preview {
    CalculatorView()
        .environment(CalculatorViewModel())
}
