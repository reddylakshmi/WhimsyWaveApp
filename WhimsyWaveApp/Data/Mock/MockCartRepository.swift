import Foundation

final class MockCartRepository: ICartRepository, @unchecked Sendable {
    private var cart: Cart = .empty

    func getCart() async throws -> Cart {
        cart
    }

    func addItem(_ product: Product, variant: ProductVariant?, quantity: Int) async throws -> Cart {
        try await Task.sleep(for: .milliseconds(200))
        if let index = cart.items.firstIndex(where: { $0.product.id == product.id }) {
            cart.items[index].quantity += quantity
        } else {
            let item = CartItem(product: product, quantity: quantity, selectedVariant: variant)
            cart.items.append(item)
        }
        return cart
    }

    func removeItem(cartItemId: String) async throws -> Cart {
        try await Task.sleep(for: .milliseconds(150))
        cart.items.removeAll { $0.id == cartItemId }
        return cart
    }

    func updateQuantity(cartItemId: String, quantity: Int) async throws -> Cart {
        try await Task.sleep(for: .milliseconds(150))
        if let index = cart.items.firstIndex(where: { $0.id == cartItemId }) {
            if quantity <= 0 {
                cart.items.remove(at: index)
            } else {
                cart.items[index].quantity = quantity
            }
        }
        return cart
    }

    func clearCart() async throws {
        cart = .empty
    }
}
