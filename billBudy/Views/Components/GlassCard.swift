import SwiftUI

struct GlassCard<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(AppSpacing.md)
            .background(AppColors.bbCardBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.cardRadius))
            .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
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
