import Foundation

enum UserMapper {
    static func map(_ dto: UserDTO) -> User {
        User(
            id: dto.id,
            email: dto.email,
            username: dto.username,
            firstName: dto.firstName,
            lastName: dto.lastName,
            phone: dto.phone,
            avatarURL: dto.avatarURL,
            addresses: (dto.addresses ?? []).map { mapAddress($0) },
            paymentMethods: (dto.paymentMethods ?? []).map { mapPayment($0) },
            defaultAddressId: dto.defaultAddressId,
            memberSince: ISO8601DateFormatter().date(from: dto.memberSince) ?? .now,
            membershipTier: MembershipTier(rawValue: dto.membershipTier) ?? .standard
        )
    }

    private static func mapPayment(_ dto: PaymentMethodDTO) -> PaymentMethod {
        PaymentMethod(
            id: dto.id,
            type: PaymentType(rawValue: dto.type) ?? .visa,
            lastFourDigits: dto.lastFourDigits,
            expiryDate: dto.expiryDate,
            cardholderName: dto.cardholderName,
            isDefault: dto.isDefault ?? false
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
}
