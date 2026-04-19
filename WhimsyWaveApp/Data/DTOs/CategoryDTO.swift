import Foundation

struct CategoryDTO: Codable, Sendable {
    let id: String
    let name: String
    let image: String
    let productCount: Int
    let subcategories: [CategoryDTO]?
    let parentId: String?
}
