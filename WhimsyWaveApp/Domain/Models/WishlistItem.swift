import Foundation

struct WishlistItem: Identifiable, Equatable, Sendable {
    let id: String
    let product: Product
    let addedAt: Date
    let priceAtAdd: Decimal

    init(
        id: String = UUID().uuidString,
        product: Product,
        addedAt: Date = .now,
        priceAtAdd: Decimal? = nil
    ) {
        self.id = id
        self.product = product
        self.addedAt = addedAt
        self.priceAtAdd = priceAtAdd ?? product.effectivePrice
    }

    var hasPriceDropped: Bool {
        product.effectivePrice < priceAtAdd
    }
}
