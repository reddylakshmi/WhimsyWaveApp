import Foundation

struct SearchResult: Equatable, Sendable {
    let query: String
    let products: [Product]
    let totalCount: Int
    let suggestions: [String]
    let currentPage: Int
    let totalPages: Int

    var hasMorePages: Bool {
        currentPage < totalPages
    }

    static let empty = SearchResult(
        query: "",
        products: [],
        totalCount: 0,
        suggestions: [],
        currentPage: 0,
        totalPages: 0
    )
}
