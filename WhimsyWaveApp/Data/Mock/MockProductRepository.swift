import Foundation

final class MockProductRepository: IProductRepository, @unchecked Sendable {
    func fetchProducts(page: Int) async throws -> [Product] {
        try await Task.sleep(for: .milliseconds(300))
        let pageSize = AppConstants.Pagination.defaultPageSize
        let start = page * pageSize
        let allProducts = Product.mockProducts
        guard start < allProducts.count else { return [] }
        let end = min(start + pageSize, allProducts.count)
        return Array(allProducts[start..<end])
    }

    func fetchProduct(id: String) async throws -> Product {
        try await Task.sleep(for: .milliseconds(200))
        guard let product = Product.mockProducts.first(where: { $0.id == id }) else {
            throw APIError.notFound
        }
        return product
    }

    func fetchFeaturedProducts() async throws -> [Product] {
        try await Task.sleep(for: .milliseconds(200))
        return Product.mockProducts.filter { $0.isFeatured }
    }

    func fetchProductsByCategory(categoryId: String, page: Int) async throws -> [Product] {
        try await Task.sleep(for: .milliseconds(300))
        let categoryMap: [String: [Product]] = [
            "CAT-001": Product.furnitureProducts,
            "CAT-002": Product.lightingProducts,
            "CAT-003": Product.bathProducts,
            "CAT-004": Product.decorProducts,
            "CAT-005": Product.outdoorProducts,
            "CAT-006": Product.beddingProducts,
            "CAT-007": Product.rugProducts,
            "CAT-008": Product.kitchenProducts,
            "CAT-009": Product.smartHomeProducts,
            "CAT-010": Product.storageProducts
        ]
        return categoryMap[categoryId] ?? Product.mockProducts
    }

    func fetchHomeSections() async throws -> [HomeSection] {
        try await Task.sleep(for: .milliseconds(400))
        return [
            HomeSection(type: .heroBanner, title: "Featured", banners: Banner.mockBanners),
            HomeSection(type: .categories, title: "Shop by Category", categories: Category.mockCategories),
            HomeSection(type: .featuredProducts, title: "Top Picks For You", subtitle: "Curated just for you", products: Product.mockProducts.filter { $0.isFeatured }),
            HomeSection(type: .onSale, title: "Deals of the Day", subtitle: "Limited time offers", products: Product.mockProducts.filter { $0.isOnSale }),
            HomeSection(type: .newArrivals, title: "Just Arrived", products: Product.mockProducts.filter { $0.isNew }),
            HomeSection(type: .trendingNow, title: "Trending Now", products: Array(Product.mockProducts.prefix(8)))
        ]
    }
}
