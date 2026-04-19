import Foundation

struct Order: Identifiable, Equatable, Sendable, Codable {
    let id: String
    let orderNumber: String
    let items: [OrderItem]
    let subtotal: Decimal
    let shippingCost: Decimal
    let tax: Decimal
    let totalAmount: Decimal
    let status: OrderStatus
    let createdAt: Date
    let updatedAt: Date
    let shippingAddress: Address
    let paymentMethod: PaymentSummary
    let trackingNumber: String?
    let estimatedDelivery: DateRange?

    var displayTotal: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = AppConstants.Currency.code
        return formatter.string(from: totalAmount as NSDecimalNumber) ?? "$0.00"
    }
}

struct PaymentSummary: Equatable, Sendable, Codable {
    let type: String
    let lastFourDigits: String
}

enum OrderStatus: String, Codable, Equatable, Sendable, CaseIterable {
    case placed
    case confirmed
    case processing
    case shipped
    case outForDelivery
    case delivered
    case cancelled
    case returned

    var displayName: String {
        switch self {
        case .placed: return "Placed"
        case .confirmed: return "Confirmed"
        case .processing: return "Processing"
        case .shipped: return "Shipped"
        case .outForDelivery: return "Out for Delivery"
        case .delivered: return "Delivered"
        case .cancelled: return "Cancelled"
        case .returned: return "Returned"
        }
    }

    var progressValue: Double {
        switch self {
        case .placed: return 0.15
        case .confirmed: return 0.3
        case .processing: return 0.45
        case .shipped: return 0.6
        case .outForDelivery: return 0.8
        case .delivered: return 1.0
        case .cancelled, .returned: return 0.0
        }
    }
}
