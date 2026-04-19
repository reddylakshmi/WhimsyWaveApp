import Foundation

struct ProductDTO: Codable, Sendable {
    let id: String
    let name: String
    let brand: String
    let description: String
    let price: Double
    let salePrice: Double?
    let currency: String
    let images: [ProductImageDTO]
    let categoryPath: [String]
    let rating: Double
    let reviewCount: Int
    let specs: [ProductSpecDTO]?
    let variants: [ProductVariantDTO]?
    let tags: [String]?
    let isInStock: Bool
    let stockCount: Int?
    let estimatedDeliveryEarliest: String?
    let estimatedDeliveryLatest: String?
    let isFeatured: Bool
    let isNew: Bool
    let createdAt: String
}

struct ProductImageDTO: Codable, Sendable {
    let url: String
    let alt: String?
}

struct ProductSpecDTO: Codable, Sendable {
    let label: String
    let value: String
}

struct ProductVariantDTO: Codable, Sendable {
    let id: String
    let name: String
    let color: String?
    let size: String?
    let additionalPrice: Double
    let isInStock: Bool
}
