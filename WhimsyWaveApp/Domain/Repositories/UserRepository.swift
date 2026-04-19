import Foundation

protocol IAuthRepository: Sendable {
    func login(username: String, password: String) async throws -> AuthResponse
    func register(email: String, username: String, password: String) async throws -> AuthResponse
    func logout() async throws
    func refreshToken() async throws -> AuthResponse
}

protocol IUserRepository: Sendable {
    func fetchProfile(userId: String) async throws -> User
    func updateProfile(_ user: User) async throws -> User
    func addAddress(_ address: Address, userId: String) async throws -> User
    func deleteAddress(addressId: String, userId: String) async throws -> User
}
