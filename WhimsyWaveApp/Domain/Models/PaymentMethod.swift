import Foundation

struct PaymentMethod: Identifiable, Equatable, Sendable, Codable {
    let id: String
    let type: PaymentType
    let lastFourDigits: String
    let expiryDate: String
    let cardholderName: String
    var isDefault: Bool

    var displayName: String {
        "\(type.displayName) •••• \(lastFourDigits)"
    }
}

enum PaymentType: String, Codable, Equatable, Sendable {
    case visa
    case mastercard
    case amex
    case applePay
    case paypal

    var displayName: String {
        switch self {
        case .visa: return "Visa"
        case .mastercard: return "Mastercard"
        case .amex: return "Amex"
        case .applePay: return "Apple Pay"
        case .paypal: return "PayPal"
        }
    }

    var iconName: String {
        switch self {
        case .visa: return "creditcard"
        case .mastercard: return "creditcard"
        case .amex: return "creditcard"
        case .applePay: return "apple.logo"
        case .paypal: return "p.circle"
        }
    }
}
