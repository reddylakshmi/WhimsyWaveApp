import SwiftUI

struct BadgeView: View {
    let text: String
    let color: Color

    init(_ text: String, color: Color = AppColors.saleBadge) {
        self.text = text
        self.color = color
    }

    var body: some View {
        Text(text)
            .font(AppTypography.badge)
            .foregroundStyle(.white)
            .padding(.horizontal, AppSpacing.sm)
            .padding(.vertical, AppSpacing.xxs)
            .background(color)
            .clipShape(Capsule())
    }
}
