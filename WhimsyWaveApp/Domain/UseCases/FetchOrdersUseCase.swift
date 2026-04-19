import Foundation

struct FetchOrdersUseCase: Sendable {
    let orderRepository: IOrderRepository

    func execute() async throws -> [Order] {
        try await orderRepository.fetchOrders()
    }
}
