import Foundation

final class MockProductRepository: IProductRepository, @unchecked Sendable {

    private var sqliteStore: SQLiteStore { ServiceContainer.current.sqliteStore }

    private func regionLocale() -> RegionLocale {
        RegionLocale.resolve(from: RegionManager.shared.currentRegion)
    }

    func fetchProducts(page: Int) async throws -> [Product] {
        try await Task.sleep(for: .milliseconds(300))
        let locale = regionLocale()
        let pageSize = AppConstants.Pagination.defaultPageSize
        return try await sqliteStore.fetchProducts(regionLocale: locale, page: page + 1, pageSize: pageSize)
    }

    func fetchProduct(id: String) async throws -> Product {
        try await Task.sleep(for: .milliseconds(200))
        let locale = regionLocale()
        guard let product = try await sqliteStore.fetchProduct(id: id, regionLocale: locale) else {
            throw APIError.notFound
        }
        return product
    }

    func fetchFeaturedProducts() async throws -> [Product] {
        try await Task.sleep(for: .milliseconds(200))
        let locale = regionLocale()
        return try await sqliteStore.fetchFeaturedProducts(regionLocale: locale)
    }

    func fetchProductsByCategory(categoryId: String, page: Int) async throws -> [Product] {
        try await Task.sleep(for: .milliseconds(300))
        let locale = regionLocale()
        let pageSize = AppConstants.Pagination.defaultPageSize
        return try await sqliteStore.fetchProductsByCategory(
            categoryId: categoryId,
            regionLocale: locale,
            page: page + 1,
            pageSize: pageSize
        )
    }

    func fetchHomeSections() async throws -> [HomeSection] {
        try await Task.sleep(for: .milliseconds(400))
        let locale = regionLocale()

        // Fetch payloads and resolve into full HomeSection objects
        let payloads = try await sqliteStore.fetchHomeSectionPayloads(regionLocale: locale)
        var sections: [HomeSection] = []

        for payload in payloads {
            let products = try await sqliteStore.fetchProductsByIds(payload.productIds, regionLocale: locale)
            let categories = !payload.categoryIds.isEmpty
                ? try await sqliteStore.fetchCategories(regionLocale: locale).filter { payload.categoryIds.contains($0.id) }
                : []
            let banners = !payload.bannerIds.isEmpty
                ? try await sqliteStore.fetchBanners(regionLocale: locale).filter { payload.bannerIds.contains($0.id) }
                : []

            guard let sectionType = HomeSection.SectionType(rawValue: payload.type) else { continue }

            sections.append(HomeSection(
                id: payload.id,
                type: sectionType,
                title: payload.title,
                subtitle: payload.subtitle,
                products: products,
                categories: categories,
                banners: banners
            ))
        }

        return sections
    }
}
