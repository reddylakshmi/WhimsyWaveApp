import Foundation

final class MockAuthRepository: IAuthRepository, @unchecked Sendable {
    func login(username: String, password: String) async throws -> AuthResponse {
        try await Task.sleep(for: .milliseconds(500))
        if username == "whimsy" && password == "whimsy123" {
            return AuthResponse(token: "mock_token_2026", refreshToken: "mock_refresh_2026", userId: "USR-001", expiresIn: 3600)
        }
        throw APIError.unauthorized
    }

    func register(email: String, username: String, password: String) async throws -> AuthResponse {
        try await Task.sleep(for: .milliseconds(500))
        return AuthResponse(token: "mock_token_new_2026", refreshToken: "mock_refresh_new_2026", userId: "USR-NEW", expiresIn: 3600)
    }

    func logout() async throws {
        try await Task.sleep(for: .milliseconds(200))
    }

    func refreshToken() async throws -> AuthResponse {
        AuthResponse(token: "mock_refreshed_token", refreshToken: "mock_refresh_2026", userId: "USR-001", expiresIn: 3600)
    }
}

final class MockUserRepository: IUserRepository, @unchecked Sendable {
    private var user: User = .mockUser

    func fetchProfile(userId: String) async throws -> User {
        try await Task.sleep(for: .milliseconds(200))
        return user
    }

    func updateProfile(_ updated: User) async throws -> User {
        try await Task.sleep(for: .milliseconds(300))
        user = updated
        return user
    }

    func addAddress(_ address: Address, userId: String) async throws -> User {
        try await Task.sleep(for: .milliseconds(200))
        var updated = user
        var addresses = updated.addresses
        addresses.append(address)
        user = User(id: updated.id, email: updated.email, username: updated.username, firstName: updated.firstName, lastName: updated.lastName, phone: updated.phone, avatarURL: updated.avatarURL, addresses: addresses, defaultAddressId: updated.defaultAddressId, memberSince: updated.memberSince, membershipTier: updated.membershipTier)
        return user
    }

    func deleteAddress(addressId: String, userId: String) async throws -> User {
        try await Task.sleep(for: .milliseconds(200))
        let filtered = user.addresses.filter { $0.id != addressId }
        user = User(id: user.id, email: user.email, username: user.username, firstName: user.firstName, lastName: user.lastName, phone: user.phone, avatarURL: user.avatarURL, addresses: filtered, defaultAddressId: user.defaultAddressId, memberSince: user.memberSince, membershipTier: user.membershipTier)
        return user
    }
}
