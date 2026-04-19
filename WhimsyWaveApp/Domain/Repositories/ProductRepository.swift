import Foundation

protocol IProductRepository: Sendable {
    func fetchProducts(page: Int) async throws -> [Product]
    func fetchProduct(id: String) async throws -> Product
    func fetchFeaturedProducts() async throws -> [Product]
    func fetchProductsByCategory(categoryId: String, page: Int) async throws -> [Product]
    func fetchHomeSections() async throws -> [HomeSection]
}
