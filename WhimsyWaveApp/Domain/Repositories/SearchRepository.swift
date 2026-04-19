import Foundation

protocol ISearchRepository: Sendable {
    func search(query: String, filter: ProductFilter?, page: Int) async throws -> SearchResult
    func fetchSuggestions(query: String) async throws -> [String]
    func fetchRecentSearches() async -> [String]
    func saveRecentSearch(_ query: String) async
    func clearRecentSearches() async
}
