import Foundation

enum CartMapper {
    static func map(_ dto: CartDTO) -> Cart {
        Cart(items: dto.items.map { mapItem($0) })
    }

    private static func mapItem(_ dto: CartItemDTO) -> CartItem {
        CartItem(
            id: dto.id,
            product: ProductMapper.map(dto.product),
            quantity: dto.quantity,
            selectedVariant: nil,
            addedAt: ISO8601DateFormatter().date(from: dto.addedAt) ?? .now
        )
    }
}
