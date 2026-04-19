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
    let defaultAddressId: String?
    let memberSince: String
    let membershipTier: String
}
