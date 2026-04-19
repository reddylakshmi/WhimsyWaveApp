import Foundation

extension User {
    static let mockUser = User(
        id: "USR-001",
        email: "sarah.johnson@email.com",
        username: "sarahj",
        firstName: "Sarah",
        lastName: "Johnson",
        phone: "+1 (555) 234-5678",
        avatarURL: nil,
        addresses: [.mockHome, .mockOffice],
        defaultAddressId: "ADDR-001",
        memberSince: Date().addingTimeInterval(-365 * 86400),
        membershipTier: .gold
    )

    static let mockGuest = User(
        id: "USR-GUEST",
        email: "",
        username: "guest",
        firstName: "Guest",
        lastName: "User",
        phone: nil,
        avatarURL: nil,
        addresses: [],
        defaultAddressId: nil,
        memberSince: .now,
        membershipTier: .standard
    )
}

extension Address {
    static let mockHome = Address(
        id: "ADDR-001",
        label: "Home",
        fullName: "Sarah Johnson",
        street: "742 Evergreen Terrace",
        apartment: "Apt 4B",
        city: "Springfield",
        state: "IL",
        zipCode: "62704",
        country: "US",
        phone: "+1 (555) 234-5678",
        isDefault: true
    )

    static let mockOffice = Address(
        id: "ADDR-002",
        label: "Office",
        fullName: "Sarah Johnson",
        street: "100 Innovation Drive",
        apartment: "Suite 300",
        city: "Springfield",
        state: "IL",
        zipCode: "62701",
        country: "US",
        phone: "+1 (555) 987-6543",
        isDefault: false
    )
}

extension PaymentMethod {
    static let mockVisa = PaymentMethod(
        id: "PM-001",
        type: .visa,
        lastFourDigits: "4242",
        expiryDate: "12/27",
        cardholderName: "Sarah Johnson",
        isDefault: true
    )

    static let mockMastercard = PaymentMethod(
        id: "PM-002",
        type: .mastercard,
        lastFourDigits: "8831",
        expiryDate: "03/28",
        cardholderName: "Sarah Johnson",
        isDefault: false
    )

    static let mockApplePay = PaymentMethod(
        id: "PM-003",
        type: .applePay,
        lastFourDigits: "",
        expiryDate: "",
        cardholderName: "Sarah Johnson",
        isDefault: false
    )
}
