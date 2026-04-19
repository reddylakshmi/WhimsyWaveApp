import Foundation

struct OrderDTO: Codable, Sendable {
    let id: String
    let orderNumber: String
    let items: [OrderItemDTO]
    let subtotal: Double
    let shippingCost: Double
    let tax: Double
    let totalAmount: Double
    let status: String
    let createdAt: String
    let updatedAt: String
    let shippingAddress: AddressDTO
    let paymentType: String
    let paymentLastFour: String
    let trackingNumber: String?
    let estimatedDeliveryEarliest: String?
    let estimatedDeliveryLatest: String?
}

struct OrderItemDTO: Codable, Sendable {
    let id: String
    let productId: String
    let name: String
    let brand: String
    let price: Double
    let quantity: Int
    let image: String
    let selectedVariant: String?
}

struct AddressDTO: Codable, Sendable {
    let id: String
    let label: String?
    let fullName: String
    let street: String
    let apartment: String?
    let city: String
    let state: String
    let zipCode: String
    let country: String
    let phone: String?
    let isDefault: Bool?
}
