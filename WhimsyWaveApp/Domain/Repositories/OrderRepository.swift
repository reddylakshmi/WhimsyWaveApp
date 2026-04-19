import Foundation

protocol IOrderRepository: Sendable {
    func placeOrder(cart: Cart, address: Address, payment: PaymentMethod) async throws -> Order
    func fetchOrders() async throws -> [Order]
    func fetchOrder(id: String) async throws -> Order
    func cancelOrder(id: String) async throws -> Order
}
