import Foundation

struct FetchHomeUseCase: Sendable {
    let productRepository: IProductRepository

    func execute() async throws -> [HomeSection] {
        try await productRepository.fetchHomeSections()
    }
}
