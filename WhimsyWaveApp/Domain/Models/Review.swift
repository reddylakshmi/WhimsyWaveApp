import Foundation

struct Review: Identifiable, Equatable, Sendable, Codable {
    let id: String
    let productId: String
    let username: String
    let rating: Int
    let title: String
    let body: String
    let isVerifiedPurchase: Bool
    let helpfulCount: Int
    let images: [String]
    let createdAt: Date

    init(
        id: String = UUID().uuidString,
        productId: String,
        username: String,
        rating: Int,
        title: String,
        body: String,
        isVerifiedPurchase: Bool = false,
        helpfulCount: Int = 0,
        images: [String] = [],
        createdAt: Date = .now
    ) {
        self.id = id
        self.productId = productId
        self.username = username
        self.rating = min(5, max(1, rating))
        self.title = title
        self.body = body
        self.isVerifiedPurchase = isVerifiedPurchase
        self.helpfulCount = helpfulCount
        self.images = images
        self.createdAt = createdAt
    }
}
