import Foundation

struct User: Equatable, Identifiable, Sendable, Codable {
    let id: String
    let email: String
    let username: String
    let firstName: String
    let lastName: String
    let phone: String?
    let avatarURL: String?
    let addresses: [Address]
    let defaultAddressId: String?
    let memberSince: Date
    let membershipTier: MembershipTier

    var fullName: String {
        "\(firstName) \(lastName)"
    }

    var initials: String {
        let f = firstName.prefix(1)
        let l = lastName.prefix(1)
        return "\(f)\(l)".uppercased()
    }

    var defaultAddress: Address? {
        addresses.first { $0.id == defaultAddressId } ?? addresses.first
    }
}

enum MembershipTier: String, Codable, Equatable, Sendable {
    case standard
    case silver
    case gold
    case platinum

    var displayName: String {
        rawValue.capitalized
    }
}

struct AuthResponse: Codable, Sendable {
    let token: String
    let refreshToken: String
    let userId: String
    let expiresIn: Int
}
