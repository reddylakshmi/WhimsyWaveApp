import Foundation

enum OrderMapper {
    private static let dateFormatter: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        return f
    }()

    static func map(_ dto: OrderDTO) -> Order {
        Order(
            id: dto.id,
            orderNumber: dto.orderNumber,
            items: dto.items.map { mapItem($0) },
            subtotal: Decimal(dto.subtotal),
            shippingCost: Decimal(dto.shippingCost),
            tax: Decimal(dto.tax),
            totalAmount: Decimal(dto.totalAmount),
            status: OrderStatus(rawValue: dto.status) ?? .placed,
            createdAt: dateFormatter.date(from: dto.createdAt) ?? .now,
            updatedAt: dateFormatter.date(from: dto.updatedAt) ?? .now,
            shippingAddress: mapAddress(dto.shippingAddress),
            paymentMethod: PaymentSummary(type: dto.paymentType, lastFourDigits: dto.paymentLastFour),
            trackingNumber: dto.trackingNumber,
            estimatedDelivery: mapDeliveryRange(earliest: dto.estimatedDeliveryEarliest, latest: dto.estimatedDeliveryLatest)
        )
    }

    static func map(_ dtos: [OrderDTO]) -> [Order] {
        dtos.map { map($0) }
    }

    private static func mapItem(_ dto: OrderItemDTO) -> OrderItem {
        OrderItem(
            id: dto.id,
            productId: dto.productId,
            name: dto.name,
            brand: dto.brand,
            price: Decimal(dto.price),
            quantity: dto.quantity,
            image: dto.image,
            selectedVariant: dto.selectedVariant
        )
    }

    private static func mapAddress(_ dto: AddressDTO) -> Address {
        Address(
            id: dto.id,
            label: dto.label ?? "Home",
            fullName: dto.fullName,
            street: dto.street,
            apartment: dto.apartment,
            city: dto.city,
            state: dto.state,
            zipCode: dto.zipCode,
            country: dto.country,
            phone: dto.phone ?? "",
            isDefault: dto.isDefault ?? false
        )
    }

    private static func mapDeliveryRange(earliest: String?, latest: String?) -> DateRange? {
        guard let e = earliest, let l = latest,
              let ed = dateFormatter.date(from: e),
              let ld = dateFormatter.date(from: l) else { return nil }
        return DateRange(earliest: ed, latest: ld)
    }
}
