import Foundation
import Observation

@Observable @MainActor
final class ProfileFeature {
    var user: User?
    var isAuthenticated = false
    var username = ""
    var password = ""
    var email = ""
    var isLoading = false
    var errorMessage: String?

    private let authRepository: IAuthRepository
    private let userRepository: IUserRepository
    private let analytics: AnalyticsClient

    init(
        authRepository: IAuthRepository = MockServiceProvider.authRepository,
        userRepository: IUserRepository = MockServiceProvider.userRepository,
        analytics: AnalyticsClient = MockServiceProvider.analyticsClient
    ) {
        self.authRepository = authRepository
        self.userRepository = userRepository
        self.analytics = analytics
    }

    func handleLogin() async {
        guard !username.isEmpty && !password.isEmpty else {
            errorMessage = "Please enter all fields."
            return
        }
        isLoading = true
        errorMessage = nil
        do {
            let response = try await authRepository.login(username: username, password: password)
            isAuthenticated = true
            user = try await userRepository.fetchProfile(userId: response.userId)
            analytics.track(.loginCompleted(method: "credentials"))
            analytics.identify(UserProperties(userId: response.userId, email: user?.email, membershipTier: user?.membershipTier.rawValue))
        } catch {
            errorMessage = "Invalid credentials. Use whimsy/whimsy123"
        }
        isLoading = false
    }

    func handleRegister() async {
        guard !email.isEmpty && !username.isEmpty && !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }
        isLoading = true
        errorMessage = nil
        do {
            let response = try await authRepository.register(email: email, username: username, password: password)
            isAuthenticated = true
            user = try await userRepository.fetchProfile(userId: response.userId)
            analytics.track(.loginCompleted(method: "register"))
        } catch {
            errorMessage = "Registration failed. Please try again."
        }
        isLoading = false
    }

    func logout() {
        Task {
            try? await authRepository.logout()
        }
        username = ""
        password = ""
        email = ""
        user = nil
        isAuthenticated = false
        errorMessage = nil
        analytics.track(.logoutCompleted)
    }

    func loadProfile() async {
        guard isAuthenticated, let userId = user?.id else { return }
        do {
            user = try await userRepository.fetchProfile(userId: userId)
        } catch {
            AppLogger.error("Failed to load profile: \(error)", category: .networking)
        }
    }
}
