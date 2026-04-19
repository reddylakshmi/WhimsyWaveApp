import Foundation
import Observation

@Observable @MainActor
final class OrdersFeature {
    var orders: [Order] = []
    var selectedOrder: Order?
    var isLoading = false
    var error: String?

    private let fetchOrdersUseCase: FetchOrdersUseCase
    private let orderRepository: IOrderRepository
    private let analytics: AnalyticsClient

    init(
        orderRepository: IOrderRepository = MockServiceProvider.orderRepository,
        analytics: AnalyticsClient = MockServiceProvider.analyticsClient
    ) {
        self.fetchOrdersUseCase = FetchOrdersUseCase(orderRepository: orderRepository)
        self.orderRepository = orderRepository
        self.analytics = analytics
    }

    func loadOrders() async {
        isLoading = true
        do {
            orders = try await fetchOrdersUseCase.execute()
        } catch {
            self.error = (error as? APIError)?.userFacingMessage ?? error.localizedDescription
        }
        isLoading = false
    }

    func cancelOrder(_ order: Order) async {
        do {
            let cancelled = try await orderRepository.cancelOrder(id: order.id)
            if let index = orders.firstIndex(where: { $0.id == order.id }) {
                orders[index] = cancelled
            }
        } catch {
            self.error = "Failed to cancel order"
        }
    }
}
