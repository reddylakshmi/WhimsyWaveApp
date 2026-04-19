import Foundation

/// Delegates to ServiceContainer.current for all services.
/// This allows features to reference a stable type while the actual
/// implementation (mock vs live) is controlled at app launch.
enum MockServiceProvider {
    static var productRepository: IProductRepository { ServiceContainer.current.productRepository }
    static var cartRepository: ICartRepository { ServiceContainer.current.cartRepository }
    static var orderRepository: IOrderRepository { ServiceContainer.current.orderRepository }
    static var authRepository: IAuthRepository { ServiceContainer.current.authRepository }
    static var userRepository: IUserRepository { ServiceContainer.current.userRepository }
    static var searchRepository: ISearchRepository { ServiceContainer.current.searchRepository }
    static var wishlistRepository: IWishlistRepository { ServiceContainer.current.wishlistRepository }
    static var analyticsClient: AnalyticsClient { ServiceContainer.current.analyticsClient }
    static var featureFlagClient: FeatureFlagClient { ServiceContainer.current.featureFlagClient }
}

final class MockSearchRepository: ISearchRepository, @unchecked Sendable {
    private var recentSearches: [String] = ["sofa", "floor lamp", "area rug"]

    func search(query: String, filter: ProductFilter?, page: Int) async throws -> SearchResult {
        try await Task.sleep(for: .milliseconds(300))
        let filtered = Product.mockProducts.filter {
            query.isEmpty || $0.name.localizedCaseInsensitiveContains(query)
                || $0.brand.localizedCaseInsensitiveContains(query)
                || $0.category.path.joined().localizedCaseInsensitiveContains(query)
        }
        return SearchResult(
            query: query,
            products: filtered,
            totalCount: filtered.count,
            suggestions: ["sofas", "sectionals", "loveseats"],
            currentPage: page,
            totalPages: 1
        )
    }

    func fetchSuggestions(query: String) async throws -> [String] {
        try await Task.sleep(for: .milliseconds(100))
        let all = ["sofa", "sectional", "dining table", "floor lamp", "area rug", "bed frame", "office chair", "throw blanket", "smart plug", "kitchen faucet"]
        return all.filter { $0.localizedCaseInsensitiveContains(query) }
    }

    func fetchRecentSearches() async -> [String] { recentSearches }

    func saveRecentSearch(_ query: String) async {
        recentSearches.removeAll { $0 == query }
        recentSearches.insert(query, at: 0)
        if recentSearches.count > AppConstants.Search.maxRecentSearches {
            recentSearches = Array(recentSearches.prefix(AppConstants.Search.maxRecentSearches))
        }
    }

    func clearRecentSearches() async { recentSearches = [] }
}

final class MockWishlistRepository: IWishlistRepository, @unchecked Sendable {
    private var items: [WishlistItem] = []

    func getWishlist() async throws -> [WishlistItem] {
        items
    }

    func addToWishlist(_ product: Product) async throws -> [WishlistItem] {
        try await Task.sleep(for: .milliseconds(200))
        guard !items.contains(where: { $0.product.id == product.id }) else { return items }
        items.append(WishlistItem(product: product))
        return items
    }

    func removeFromWishlist(productId: String) async throws -> [WishlistItem] {
        try await Task.sleep(for: .milliseconds(150))
        items.removeAll { $0.product.id == productId }
        return items
    }

    func isInWishlist(productId: String) async -> Bool {
        items.contains { $0.product.id == productId }
    }
}
