import SwiftUI

struct GlassCard<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(AppSpacing.md)
            .background(AppColors.bbCardBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.cardRadius))
            .overlay(
                RoundedRectangle(cornerRadius: AppSpacing.cardRadius)
                    .stroke(AppColors.bbCardBorder, lineWidth: 1)
            )
            .shadow(color: AppColors.bbCardShadow, radius: 10, y: 5)
    }
}

#Preview {
    GlassCard {
        Text("Hello, BillBuddy!")
            .font(AppTypography.headline)
            .foregroundStyle(AppColors.bbPrimaryText)
    }
    .padding()
}
