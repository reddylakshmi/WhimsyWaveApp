import Foundation

/// The complete assortment data for a single region-locale.
/// Decoded from a bundled or cloud-fetched JSON file.
nonisolated struct AssortmentPayload: Codable, Sendable {
    let products: [Product]
    let categories: [Category]
    let banners: [Banner]
    let homeSections: [HomeSectionPayload]
    let version: String
    let checksum: String
}

/// A lightweight representation of a home section for JSON storage.
/// Unlike `HomeSection`, this stores IDs rather than full objects.
nonisolated struct HomeSectionPayload: Codable, Sendable {
    let id: String
    let type: String
    let title: String
    let subtitle: String?
    let productIds: [String]
    let categoryIds: [String]
    let bannerIds: [String]
    let sortOrder: Int
}
