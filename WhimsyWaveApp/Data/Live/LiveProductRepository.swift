import Foundation

final class LiveProductRepository: IProductRepository, @unchecked Sendable {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = LiveAPIClient()) {
        self.apiClient = apiClient
    }

    func fetchProducts(page: Int) async throws -> [Product] {
        let dtos: [ProductDTO] = try await apiClient.request(.searchProducts(query: "", page: page))
        return ProductMapper.map(dtos)
    }

    func fetchProduct(id: String) async throws -> Product {
        let dto: ProductDTO = try await apiClient.request(.productDetail(id: id))
        return ProductMapper.map(dto)
    }

    func fetchFeaturedProducts() async throws -> [Product] {
        let dtos: [ProductDTO] = try await apiClient.request(.homeContent)
        return ProductMapper.map(dtos)
    }

    func fetchProductsByCategory(categoryId: String, page: Int) async throws -> [Product] {
        let dtos: [ProductDTO] = try await apiClient.request(.categoryProducts(id: categoryId, page: page))
        return ProductMapper.map(dtos)
    }

    func fetchHomeSections() async throws -> [HomeSection] {
        let dtos: [ProductDTO] = try await apiClient.request(.homeContent)
        let products = ProductMapper.map(dtos)
        return [
            HomeSection(type: .featuredProducts, title: "Featured", products: products.filter { $0.isFeatured }),
            HomeSection(type: .newArrivals, title: "New Arrivals", products: products.filter { $0.isNew })
        ]
    }
}
