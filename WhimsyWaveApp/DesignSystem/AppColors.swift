import SwiftUI

enum AppColors {
    // MARK: - Brand
    static let primary = Color("Primary", bundle: .main)
    static let secondary = Color("Secondary", bundle: .main)
    static let accent = Color.accentColor

    // MARK: - Semantic
    static let background = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
    static let tertiaryBackground = Color(.tertiarySystemBackground)
    static let groupedBackground = Color(.systemGroupedBackground)

    // MARK: - Text
    static let textPrimary = Color(.label)
    static let textSecondary = Color(.secondaryLabel)
    static let textTertiary = Color(.tertiaryLabel)

    // MARK: - Status
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    static let info = Color.blue

    // MARK: - UI Elements
    static let separator = Color(.separator)
    static let border = Color(.systemGray4)
    static let cardBackground = Color(.secondarySystemBackground)
    static let shimmer = Color(.systemGray5)

    // MARK: - Sale / Promotion
    static let saleBadge = Color.red
    static let saleText = Color.white
    static let promotionBanner = Color.orange
}
