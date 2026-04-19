import Foundation

struct CheckoutUseCase: Sendable {
    let orderRepository: IOrderRepository
    let cartRepository: ICartRepository

    func execute(cart: Cart, address: Address, payment: PaymentMethod) async throws -> Order {
        let order = try await orderRepository.placeOrder(cart: cart, address: address, payment: payment)
        try await cartRepository.clearCart()
        return order
    }
}
