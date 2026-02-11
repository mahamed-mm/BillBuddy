import SwiftUI

struct CurrencyPickerView: View {
    @Environment(CalculatorViewModel.self) private var viewModel

    var body: some View {
        @Bindable var viewModel = viewModel

        Picker("Currency", selection: $viewModel.selectedCurrency) {
            ForEach(Currency.allCases) { currency in
                Text("\(currency.flag) \(currency.rawValue.uppercased())")
                    .tag(currency)
            }
        }
        .pickerStyle(.segmented)
        .tint(AppColors.bbTeal)
        .onChange(of: viewModel.selectedCurrency) {
            viewModel.savePreferences()
        }
    }
}

#Preview {
    CurrencyPickerView()
        .padding()
        .environment(CalculatorViewModel())
}
