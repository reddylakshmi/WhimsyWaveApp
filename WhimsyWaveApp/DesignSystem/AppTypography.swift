import SwiftUI

enum AppTypography {
    // MARK: - Display
    static let largeTitle: Font = .largeTitle
    static let title: Font = .title
    static let title2: Font = .title2
    static let title3: Font = .title3

    // MARK: - Body
    static let headline: Font = .headline
    static let subheadline: Font = .subheadline
    static let body: Font = .body
    static let callout: Font = .callout

    // MARK: - Supporting
    static let footnote: Font = .footnote
    static let caption: Font = .caption
    static let caption2: Font = .caption2

    // MARK: - Weighted Variants
    static let price: Font = .title3.bold()
    static let salePrice: Font = .title3.bold()
    static let originalPrice: Font = .subheadline
    static let badge: Font = .caption.bold()
    static let sectionHeader: Font = .title2.bold()
    static let cardTitle: Font = .headline
    static let cardSubtitle: Font = .subheadline
    static let buttonLabel: Font = .headline
    static let tabLabel: Font = .caption2
}
