import SwiftUI

struct TipPresetButton: View {
    let preset: TipPreset
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(preset.displayText)
                .font(AppTypography.body)
                .foregroundStyle(isSelected ? AppColors.bbTeal : AppColors.bbPrimaryText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppSpacing.sm)
                .background(isSelected ? AppColors.bbSelectedChip : .clear)
                .clipShape(RoundedRectangle(cornerRadius: AppSpacing.cornerRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: AppSpacing.cornerRadius)
                        .strokeBorder(
                            isSelected ? AppColors.bbSelectedBorder : AppColors.bbUnselectedBorder,
                            lineWidth: 1.5
                        )
                )
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(preset.displayText) tip")
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
    }
}

#Preview {
    HStack(spacing: AppSpacing.md) {
        TipPresetButton(preset: .fifteen, isSelected: true) {}
        TipPresetButton(preset: .twenty, isSelected: false) {}
    }
    .padding()
}
