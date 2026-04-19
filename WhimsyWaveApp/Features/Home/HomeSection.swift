import Foundation

struct HomeSection: Identifiable, Equatable, Sendable {
    let id: String
    let type: SectionType
    let title: String
    let subtitle: String?
    let products: [Product]
    let categories: [Category]
    let banners: [Banner]

    init(
        id: String = UUID().uuidString,
        type: SectionType,
        title: String,
        subtitle: String? = nil,
        products: [Product] = [],
        categories: [Category] = [],
        banners: [Banner] = []
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.subtitle = subtitle
        self.products = products
        self.categories = categories
        self.banners = banners
    }

    enum SectionType: String, Equatable, Sendable {
        case heroBanner
        case categories
        case featuredProducts
        case newArrivals
        case onSale
        case trendingNow
        case recentlyViewed
        case recommended
    }
}
