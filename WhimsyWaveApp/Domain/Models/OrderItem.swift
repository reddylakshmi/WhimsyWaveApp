import Foundation

struct OrderItem: Identifiable, Equatable, Sendable, Codable {
    let id: String
    let productId: String
    let name: String
    let brand: String
    let price: Decimal
    let quantity: Int
    let image: String
    let selectedVariant: String?

    var lineTotal: Decimal {
        price * Decimal(quantity)
    }
}
