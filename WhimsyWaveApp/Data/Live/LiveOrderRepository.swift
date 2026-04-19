import Foundation

final class LiveOrderRepository: IOrderRepository, @unchecked Sendable {
    private let apiClient: APIClientProtocol
    private let userId: String

    init(apiClient: APIClientProtocol = LiveAPIClient(), userId: String = "current") {
        self.apiClient = apiClient
        self.userId = userId
    }

    func placeOrder(cart: Cart, address: Address, payment: PaymentMethod) async throws -> Order {
        struct CheckoutBody: Encodable, Sendable {
            let addressId: String
            let paymentMethodId: String
        }
        let body = CheckoutBody(addressId: address.id, paymentMethodId: payment.id)
        let dto: OrderDTO = try await apiClient.request(.checkout, body: body)
        return OrderMapper.map(dto)
    }

    func fetchOrders() async throws -> [Order] {
        let dtos: [OrderDTO] = try await apiClient.request(.orders(userId: userId))
        return OrderMapper.map(dtos)
    }

    func fetchOrder(id: String) async throws -> Order {
        let dto: OrderDTO = try await apiClient.request(.orderDetail(id: id))
        return OrderMapper.map(dto)
    }

    func cancelOrder(id: String) async throws -> Order {
        let dto: OrderDTO = try await apiClient.request(.orderDetail(id: id))
        return OrderMapper.map(dto)
    }
}
