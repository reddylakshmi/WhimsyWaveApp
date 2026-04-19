import Foundation

struct SearchProductsUseCase: Sendable {
    let searchRepository: ISearchRepository

    func execute(query: String, filter: ProductFilter?, page: Int) async throws -> SearchResult {
        try await searchRepository.search(query: query, filter: filter, page: page)
    }
}
