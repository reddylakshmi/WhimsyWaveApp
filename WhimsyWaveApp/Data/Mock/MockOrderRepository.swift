import Foundation

final class MockOrderRepository: IOrderRepository, @unchecked Sendable {
    private var orders: [Order] = Order.mockOrders

    func placeOrder(cart: Cart, address: Address, payment: PaymentMethod) async throws -> Order {
        try await Task.sleep(for: .milliseconds(500))
        let items = cart.items.map { cartItem in
            OrderItem(
                id: UUID().uuidString,
                productId: cartItem.product.id,
                name: cartItem.product.name,
                brand: cartItem.product.brand,
                price: cartItem.product.effectivePrice,
                quantity: cartItem.quantity,
                image: cartItem.product.primaryImage,
                selectedVariant: cartItem.selectedVariant?.name
            )
        }
        let subtotal = cart.totalPrice
        let tax = subtotal * AppConstants.Tax.rate
        let shipping = subtotal > AppConstants.Shipping.freeShippingThreshold ? Decimal.zero : AppConstants.Shipping.standardShippingCost
        let order = Order(
            id: UUID().uuidString,
            orderNumber: "\(AppConstants.Order.numberPrefix)\(Int.random(in: 10000...99999))",
            items: items,
            subtotal: subtotal,
            shippingCost: shipping,
            tax: tax,
            totalAmount: subtotal + tax + shipping,
            status: .placed,
            createdAt: .now,
            updatedAt: .now,
            shippingAddress: address,
            paymentMethod: PaymentSummary(type: payment.type.displayName, lastFourDigits: payment.lastFourDigits),
            trackingNumber: nil,
            estimatedDelivery: .init(earliest: Date().addingTimeInterval(5 * 86400), latest: Date().addingTimeInterval(9 * 86400))
        )
        orders.insert(order, at: 0)
        return order
    }

    func fetchOrders() async throws -> [Order] {
        try await Task.sleep(for: .milliseconds(300))
        return orders
    }

    func fetchOrder(id: String) async throws -> Order {
        try await Task.sleep(for: .milliseconds(200))
        guard let order = orders.first(where: { $0.id == id }) else {
            throw APIError.notFound
        }
        return order
    }

    func cancelOrder(id: String) async throws -> Order {
        try await Task.sleep(for: .milliseconds(300))
        guard let index = orders.firstIndex(where: { $0.id == id }) else {
            throw APIError.notFound
        }
        let original = orders[index]
        let cancelled = Order(
            id: original.id, orderNumber: original.orderNumber, items: original.items,
            subtotal: original.subtotal, shippingCost: original.shippingCost, tax: original.tax,
            totalAmount: original.totalAmount, status: .cancelled, createdAt: original.createdAt,
            updatedAt: .now, shippingAddress: original.shippingAddress,
            paymentMethod: original.paymentMethod, trackingNumber: nil, estimatedDelivery: nil
        )
        orders[index] = cancelled
        return cancelled
    }
}
