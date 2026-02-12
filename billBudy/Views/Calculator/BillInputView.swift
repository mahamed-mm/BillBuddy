import SwiftUI

struct BillInputView: View {
    @Environment(CalculatorViewModel.self) private var viewModel
    @FocusState private var isFieldFocused: Bool

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
                .focused($isFieldFocused)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            isFieldFocused = false
                        }
                    }
                }
        }
    }
}

#Preview {
    BillInputView()
        .padding()
        .environment(CalculatorViewModel())
}
