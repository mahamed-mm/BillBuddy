import SwiftUI

struct BillInputView: View {
    @Environment(CalculatorViewModel.self) private var viewModel

    var body: some View {
        @Bindable var viewModel = viewModel

        HStack(alignment: .firstTextBaseline, spacing: AppSpacing.sm) {
            Text(viewModel.selectedCurrency.symbol)
                .font(AppTypography.largeTitle)
                .foregroundStyle(AppColors.bbSecondaryText)

            TextField("0.00", text: $viewModel.billAmountText)
                .font(AppTypography.mono)
                .foregroundStyle(AppColors.bbPrimaryText)
                .keyboardType(.decimalPad)
        }
    }
}

#Preview {
    BillInputView()
        .padding()
        .environment(CalculatorViewModel())
}
