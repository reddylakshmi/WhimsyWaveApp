import Foundation

struct Category: Identifiable, Equatable, Sendable, Codable {
    let id: String
    let name: String
    let image: String
    let productCount: Int
    let subcategories: [Category]
    let parentId: String?

    init(
        id: String,
        name: String,
        image: String,
        productCount: Int,
        subcategories: [Category] = [],
        parentId: String? = nil
    ) {
        self.id = id
        self.name = name
        self.image = image
        self.productCount = productCount
        self.subcategories = subcategories
        self.parentId = parentId
    }
}
