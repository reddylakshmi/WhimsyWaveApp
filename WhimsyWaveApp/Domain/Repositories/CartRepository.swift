import Foundation

protocol ICartRepository: Sendable {
    func getCart() async throws -> Cart
    func addItem(_ product: Product, variant: ProductVariant?, quantity: Int) async throws -> Cart
    func removeItem(cartItemId: String) async throws -> Cart
    func updateQuantity(cartItemId: String, quantity: Int) async throws -> Cart
    func clearCart() async throws
}
