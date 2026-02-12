import SwiftUI

struct ResultsCardView: View {
    @Environment(CalculatorViewModel.self) private var viewModel
    @State private var isVisible = false
    @State private var hasTriggeredHaptic = false

    private var rows: [(label: String, value: String)] {
        var result = [
            ("Tip", CurrencyFormatter.format(amount: viewModel.tipAmount, currency: viewModel.selectedCurrency)),
            ("Total", CurrencyFormatter.format(amount: viewModel.totalAmount, currency: viewModel.selectedCurrency))
        ]
        if viewModel.splitCount > 1 {
            result.append(("Per Person", CurrencyFormatter.format(amount: viewModel.perPersonAmount, currency: viewModel.selectedCurrency)))
        }
        return result
    }

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Results")
                    .font(AppTypography.headline)
                    .foregroundStyle(AppColors.bbPrimaryText)

                ForEach(Array(rows.enumerated()), id: \.offset) { index, row in
                    BreakdownRow(label: row.label, value: row.value)
                        .offset(y: isVisible ? 0 : 20)
                        .opacity(isVisible ? 1 : 0)
                        .animation(
                            .spring(response: 0.4, dampingFraction: 0.7)
                            .delay(Double(index) * 0.05),
                            value: isVisible
                        )
                }
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: viewModel.billAmountText)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: viewModel.effectiveTipPercent)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: viewModel.splitCount)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: viewModel.selectedCurrency)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: viewModel.selectedRounding)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Results")
        .accessibilityValue(rows.map { "\($0.label): \($0.value)" }.joined(separator: ", "))
        .onAppear {
            isVisible = true
        }
        .onChange(of: viewModel.billAmount) { _, newValue in
            if newValue > 0 && !hasTriggeredHaptic {
                hasTriggeredHaptic = true
                HapticManager.success()
            }
        }
    }
}

#Preview {
    ResultsCardView()
        .padding()
        .environment(CalculatorViewModel())
}
