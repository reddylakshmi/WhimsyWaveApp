import Foundation

struct CartItem: Identifiable, Equatable, Sendable {
    let id: String
    let product: Product
    var quantity: Int
    let selectedVariant: ProductVariant?
    let addedAt: Date

    init(
        id: String = UUID().uuidString,
        product: Product,
        quantity: Int = 1,
        selectedVariant: ProductVariant? = nil,
        addedAt: Date = .now
    ) {
        self.id = id
        self.product = product
        self.quantity = quantity
        self.selectedVariant = selectedVariant
        self.addedAt = addedAt
    }

    var lineTotal: Decimal {
        product.effectivePrice * Decimal(quantity)
    }
}
