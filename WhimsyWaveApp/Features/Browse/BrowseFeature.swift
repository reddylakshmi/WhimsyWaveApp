import Foundation
import Observation

@Observable @MainActor
final class BrowseFeature {
    var categories: [Category] = []
    var selectedCategory: Category?
    var products: [Product] = []
    var filter: ProductFilter = .default
    var isLoading = false
    var error: String?

    private let productRepository: IProductRepository
    private let analytics: AnalyticsClient

    init(
        productRepository: IProductRepository = MockServiceProvider.productRepository,
        analytics: AnalyticsClient = MockServiceProvider.analyticsClient
    ) {
        self.productRepository = productRepository
        self.analytics = analytics
    }

    func loadCategories() async {
        guard categories.isEmpty else { return }
        isLoading = true
        do {
            let sections = try await productRepository.fetchHomeSections()
            categories = sections.first(where: { $0.type == .categories })?.categories ?? Category.mockCategories
            if let first = categories.first {
                await selectCategory(first)
            }
        } catch {
            self.error = (error as? APIError)?.userFacingMessage ?? error.localizedDescription
        }
        isLoading = false
    }

    func refresh() async {
        if let category = selectedCategory {
            await selectCategory(category)
        } else {
            categories = []
            await loadCategories()
        }
    }

    func selectCategory(_ category: Category) async {
        selectedCategory = category
        isLoading = true
        do {
            products = try await productRepository.fetchProductsByCategory(categoryId: category.id, page: 0)
        } catch {
            self.error = (error as? APIError)?.userFacingMessage ?? error.localizedDescription
        }
        isLoading = false
    }
}
