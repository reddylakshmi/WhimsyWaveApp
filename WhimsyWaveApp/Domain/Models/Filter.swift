import Foundation

struct ProductFilter: Equatable, Sendable {
    var categories: [String]
    var priceRange: ClosedRange<Decimal>
    var brands: [String]
    var sortBy: SortOption
    var rating: Int?
    var inStockOnly: Bool

    init(
        categories: [String] = [],
        priceRange: ClosedRange<Decimal> = 0...10000,
        brands: [String] = [],
        sortBy: SortOption = .relevance,
        rating: Int? = nil,
        inStockOnly: Bool = false
    ) {
        self.categories = categories
        self.priceRange = priceRange
        self.brands = brands
        self.sortBy = sortBy
        self.rating = rating
        self.inStockOnly = inStockOnly
    }

    var hasActiveFilters: Bool {
        !categories.isEmpty || !brands.isEmpty || rating != nil || inStockOnly || sortBy != .relevance
    }

    static let `default` = ProductFilter()
}

enum SortOption: String, CaseIterable, Equatable, Sendable {
    case relevance
    case priceLowToHigh
    case priceHighToLow
    case newest
    case topRated
    case bestSelling

    var displayName: String {
        switch self {
        case .relevance: return "Relevance"
        case .priceLowToHigh: return "Price: Low to High"
        case .priceHighToLow: return "Price: High to Low"
        case .newest: return "Newest"
        case .topRated: return "Top Rated"
        case .bestSelling: return "Best Selling"
        }
    }
}

struct FilterOption: Identifiable, Equatable, Sendable {
    let id: String
    let name: String
    let count: Int
    var isSelected: Bool
}
