import Foundation

final class LiveCartRepository: ICartRepository, @unchecked Sendable {
    private let apiClient: APIClientProtocol
    private let userId: String

    init(apiClient: APIClientProtocol = LiveAPIClient(), userId: String = "current") {
        self.apiClient = apiClient
        self.userId = userId
    }

    func getCart() async throws -> Cart {
        let dto: CartDTO = try await apiClient.request(.cart(userId: userId))
        return CartMapper.map(dto)
    }

    func addItem(_ product: Product, variant: ProductVariant?, quantity: Int) async throws -> Cart {
        struct AddBody: Encodable, Sendable { let productId: String; let quantity: Int; let variantId: String? }
        let body = AddBody(productId: product.id, quantity: quantity, variantId: variant?.id)
        let dto: CartDTO = try await apiClient.request(.addToCart(userId: userId), body: body)
        return CartMapper.map(dto)
    }

    func removeItem(cartItemId: String) async throws -> Cart {
        let dto: CartDTO = try await apiClient.request(.removeCartItem(userId: userId, productId: cartItemId))
        return CartMapper.map(dto)
    }

    func updateQuantity(cartItemId: String, quantity: Int) async throws -> Cart {
        struct UpdateBody: Encodable, Sendable { let quantity: Int }
        let dto: CartDTO = try await apiClient.request(.updateCartItem(userId: userId, productId: cartItemId), body: UpdateBody(quantity: quantity))
        return CartMapper.map(dto)
    }

    func clearCart() async throws {
        _ = try await getCart()
    }
}
