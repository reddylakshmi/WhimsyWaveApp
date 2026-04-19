import SwiftUI

struct PriceView: View {
    let currentPrice: Double
    let originalPrice: Double?
    let currencySymbol: String

    init(current: Double, original: Double? = nil, currency: String = "$") {
        self.currentPrice = current
        self.originalPrice = original
        self.currencySymbol = currency
    }

    private var isOnSale: Bool {
        guard let original = originalPrice else { return false }
        return currentPrice < original
    }

    var body: some View {
        HStack(spacing: AppSpacing.xs) {
            Text("\(currencySymbol)\(currentPrice, specifier: "%.2f")")
                .font(AppTypography.price)
                .foregroundStyle(isOnSale ? AppColors.saleBadge : AppColors.textPrimary)

            if isOnSale, let original = originalPrice {
                Text("\(currencySymbol)\(original, specifier: "%.2f")")
                    .font(AppTypography.originalPrice)
                    .foregroundStyle(AppColors.textTertiary)
                    .strikethrough()
            }
        }
    }
}
