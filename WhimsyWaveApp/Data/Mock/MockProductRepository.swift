import Foundation

final class MockProductRepository: IProductRepository, @unchecked Sendable {

    /// Fetches products localized for the current region via the CMS content provider
    private func products(for region: Region) -> [Product] {
        CMSContentProvider.products(for: region)
    }

    func fetchProducts(page: Int) async throws -> [Product] {
        try await Task.sleep(for: .milliseconds(300))
        let region = await RegionManager.shared.currentRegion
        let allProducts = products(for: region)
        let pageSize = AppConstants.Pagination.defaultPageSize
        let start = page * pageSize
        guard start < allProducts.count else { return [] }
        let end = min(start + pageSize, allProducts.count)
        return Array(allProducts[start..<end])
    }

    func fetchProduct(id: String) async throws -> Product {
        try await Task.sleep(for: .milliseconds(200))
        let region = await RegionManager.shared.currentRegion
        guard let product = products(for: region).first(where: { $0.id == id }) else {
            throw APIError.notFound
        }
        return product
    }

    func fetchFeaturedProducts() async throws -> [Product] {
        try await Task.sleep(for: .milliseconds(200))
        let region = await RegionManager.shared.currentRegion
        return products(for: region).filter { $0.isFeatured }
    }

    func fetchProductsByCategory(categoryId: String, page: Int) async throws -> [Product] {
        try await Task.sleep(for: .milliseconds(300))
        let region = await RegionManager.shared.currentRegion
        let regionProducts = products(for: region)

        // Map category IDs to their root category name (in English, since product data uses English root)
        let categoryMap: [String: [String]] = [
            "CAT-001": ["Furniture", "Mobilier"],
            "CAT-002": ["Lighting", "Éclairage"],
            "CAT-003": ["Bath", "Salle de bain"],
            "CAT-004": ["Decor", "Décoration"],
            "CAT-005": ["Outdoor", "Extérieur"],
            "CAT-006": ["Bedding", "Literie"],
            "CAT-007": ["Rugs", "Tapis"],
            "CAT-008": ["Kitchen", "Cuisine"],
            "CAT-009": ["Smart Home", "Maison intelligente"],
            "CAT-010": ["Storage", "Rangement"]
        ]
        guard let categories = categoryMap[categoryId] else { return regionProducts }
        return regionProducts.filter { product in
            categories.contains(where: { product.category.path.first == $0 })
        }
    }

    func fetchHomeSections() async throws -> [HomeSection] {
        try await Task.sleep(for: .milliseconds(400))
        let region = await RegionManager.shared.currentRegion
        let allProducts = products(for: region)
        let titles = CMSContentProvider.homeSectionTitles(for: region)
        let banners = CMSContentProvider.banners(for: region)
        let categories = CMSContentProvider.categories(for: region)

        return [
            HomeSection(type: .heroBanner, title: titles.featured, banners: banners),
            HomeSection(type: .categories, title: titles.shopByCategory, categories: categories),
            HomeSection(type: .featuredProducts, title: titles.topPicks, subtitle: titles.topPicksSubtitle, products: allProducts.filter { $0.isFeatured }),
            HomeSection(type: .onSale, title: titles.dealsOfTheDay, subtitle: titles.dealsSubtitle, products: allProducts.filter { $0.isOnSale }),
            HomeSection(type: .newArrivals, title: titles.justArrived, products: allProducts.filter { $0.isNew }),
            HomeSection(type: .trendingNow, title: titles.trendingNow, products: Array(allProducts.prefix(8)))
        ]
    }
}
