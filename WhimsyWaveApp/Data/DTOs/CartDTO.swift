import Foundation

struct CartDTO: Codable, Sendable {
    let items: [CartItemDTO]
}

struct CartItemDTO: Codable, Sendable {
    let id: String
    let product: ProductDTO
    let quantity: Int
    let selectedVariantId: String?
    let addedAt: String
}
