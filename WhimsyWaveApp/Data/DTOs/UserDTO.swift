import Foundation

struct UserDTO: Codable, Sendable {
    let id: String
    let email: String
    let username: String
    let firstName: String
    let lastName: String
    let phone: String?
    let avatarURL: String?
    let addresses: [AddressDTO]?
    let paymentMethods: [PaymentMethodDTO]?
    let defaultAddressId: String?
    let memberSince: String
    let membershipTier: String
}

struct PaymentMethodDTO: Codable, Sendable {
    let id: String
    let type: String
    let lastFourDigits: String
    let expiryDate: String
    let cardholderName: String
    let isDefault: Bool?
}
