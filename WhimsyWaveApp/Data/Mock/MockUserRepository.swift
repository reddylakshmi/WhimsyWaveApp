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
        var addresses = user.addresses
        addresses.append(address)
        user = user.with(addresses: addresses)
        return user
    }

    func deleteAddress(addressId: String, userId: String) async throws -> User {
        try await Task.sleep(for: .milliseconds(200))
        let filtered = user.addresses.filter { $0.id != addressId }
        user = user.with(addresses: filtered)
        return user
    }

    func updateAddress(_ address: Address, userId: String) async throws -> User {
        try await Task.sleep(for: .milliseconds(200))
        var addresses = user.addresses
        if let index = addresses.firstIndex(where: { $0.id == address.id }) {
            addresses[index] = address
        }
        user = user.with(addresses: addresses)
        return user
    }

    func addPaymentMethod(_ method: PaymentMethod, userId: String) async throws -> User {
        try await Task.sleep(for: .milliseconds(200))
        var methods = user.paymentMethods
        methods.append(method)
        user = user.with(paymentMethods: methods)
        return user
    }

    func deletePaymentMethod(methodId: String, userId: String) async throws -> User {
        try await Task.sleep(for: .milliseconds(200))
        let filtered = user.paymentMethods.filter { $0.id != methodId }
        user = user.with(paymentMethods: filtered)
        return user
    }
}
