import Foundation

final class LiveAuthRepository: IAuthRepository, @unchecked Sendable {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = LiveAPIClient()) {
        self.apiClient = apiClient
    }

    func login(username: String, password: String) async throws -> AuthResponse {
        struct LoginBody: Encodable, Sendable { let username: String; let password: String }
        let response: AuthResponse = try await apiClient.request(.login, body: LoginBody(username: username, password: password))
        KeychainStore.save(response.token, for: .authToken)
        KeychainStore.save(response.refreshToken, for: .refreshToken)
        KeychainStore.save(response.userId, for: .userId)
        return response
    }

    func register(email: String, username: String, password: String) async throws -> AuthResponse {
        struct RegisterBody: Encodable, Sendable { let email: String; let username: String; let password: String }
        let response: AuthResponse = try await apiClient.request(.register, body: RegisterBody(email: email, username: username, password: password))
        KeychainStore.save(response.token, for: .authToken)
        return response
    }

    func logout() async throws {
        KeychainStore.clearAll()
    }

    func refreshToken() async throws -> AuthResponse {
        let response: AuthResponse = try await apiClient.request(.refreshToken)
        KeychainStore.save(response.token, for: .authToken)
        return response
    }
}

final class LiveUserRepository: IUserRepository, @unchecked Sendable {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = LiveAPIClient()) {
        self.apiClient = apiClient
    }

    func fetchProfile(userId: String) async throws -> User {
        let dto: UserDTO = try await apiClient.request(.userProfile(id: userId))
        return UserMapper.map(dto)
    }

    func updateProfile(_ user: User) async throws -> User {
        let dto: UserDTO = try await apiClient.request(.updateProfile(id: user.id))
        return UserMapper.map(dto)
    }

    func addAddress(_ address: Address, userId: String) async throws -> User {
        let dto: UserDTO = try await apiClient.request(.addAddress(userId: userId), body: address)
        return UserMapper.map(dto)
    }

    func updateAddress(_ address: Address, userId: String) async throws -> User {
        let dto: UserDTO = try await apiClient.request(.updateAddress(userId: userId, addressId: address.id), body: address)
        return UserMapper.map(dto)
    }

    func deleteAddress(addressId: String, userId: String) async throws -> User {
        let dto: UserDTO = try await apiClient.request(.deleteAddress(userId: userId, addressId: addressId))
        return UserMapper.map(dto)
    }

    func addPaymentMethod(_ method: PaymentMethod, userId: String) async throws -> User {
        let dto: UserDTO = try await apiClient.request(.addPaymentMethod(userId: userId), body: method)
        return UserMapper.map(dto)
    }

    func deletePaymentMethod(methodId: String, userId: String) async throws -> User {
        let dto: UserDTO = try await apiClient.request(.deletePaymentMethod(userId: userId, methodId: methodId))
        return UserMapper.map(dto)
    }
}
