import Foundation
import Observation

@Observable @MainActor
final class SearchFeature {
    var query = ""
    var results: [Product] = []
    var suggestions: [String] = []
    var recentSearches: [String] = []
    var filter: ProductFilter = .default
    var isLoading = false
    var isSearching = false
    var error: String?

    private let searchRepository: ISearchRepository
    private let cartRepository: ICartRepository
    private let analytics: AnalyticsClient

    init(
        searchRepository: ISearchRepository = MockServiceProvider.searchRepository,
        cartRepository: ICartRepository = MockServiceProvider.cartRepository,
        analytics: AnalyticsClient = MockServiceProvider.analyticsClient
    ) {
        self.searchRepository = searchRepository
        self.cartRepository = cartRepository
        self.analytics = analytics
    }

    func onAppear() async {
        recentSearches = await searchRepository.fetchRecentSearches()
    }

    func search() async {
        guard query.count >= AppConstants.Search.minQueryLength else {
            results = []
            isSearching = false
            return
        }
        isSearching = true
        isLoading = true
        do {
            let result = try await searchRepository.search(query: query, filter: filter, page: 0)
            results = result.products
            analytics.track(.searchPerformed(query: query, resultCount: result.totalCount))
            await searchRepository.saveRecentSearch(query)
            recentSearches = await searchRepository.fetchRecentSearches()
        } catch {
            self.error = (error as? APIError)?.userFacingMessage ?? error.localizedDescription
        }
        isLoading = false
    }

    func fetchSuggestions() async {
        guard query.count >= AppConstants.Search.minQueryLength else {
            suggestions = []
            return
        }
        do {
            suggestions = try await searchRepository.fetchSuggestions(query: query)
        } catch {
            suggestions = []
        }
    }

    func clearRecentSearches() async {
        await searchRepository.clearRecentSearches()
        recentSearches = []
    }

    func addToCart(product: Product) async {
        _ = try? await cartRepository.addItem(product, variant: nil, quantity: 1)
        analytics.track(.addedToCart(productId: product.id, quantity: 1))
    }
}
