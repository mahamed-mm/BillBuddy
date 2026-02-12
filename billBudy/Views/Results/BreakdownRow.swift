import SwiftUI

struct BreakdownRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(AppTypography.body)
                .foregroundStyle(AppColors.bbSecondaryText)

            Spacer()

            Text(value)
                .font(AppTypography.mono)
                .foregroundStyle(AppColors.bbPrimaryText)
                .contentTransition(.numericText())
        }
    }
}

#Preview {
    BreakdownRow(label: "Tip", value: "$15.00")
        .padding()
}
