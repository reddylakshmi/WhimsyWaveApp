import Foundation

/// Central dependency container for all app services.
/// Switch between mock and live by changing `ServiceContainer.current` at app launch.
final class ServiceContainer: @unchecked Sendable {
    let productRepository: IProductRepository
    let cartRepository: ICartRepository
    let orderRepository: IOrderRepository
    let authRepository: IAuthRepository
    let userRepository: IUserRepository
    let searchRepository: ISearchRepository
    let wishlistRepository: IWishlistRepository
    let analyticsClient: AnalyticsClient
    let featureFlagClient: FeatureFlagClient

    init(
        productRepository: IProductRepository,
        cartRepository: ICartRepository,
        orderRepository: IOrderRepository,
        authRepository: IAuthRepository,
        userRepository: IUserRepository,
        searchRepository: ISearchRepository,
        wishlistRepository: IWishlistRepository,
        analyticsClient: AnalyticsClient,
        featureFlagClient: FeatureFlagClient
    ) {
        self.productRepository = productRepository
        self.cartRepository = cartRepository
        self.orderRepository = orderRepository
        self.authRepository = authRepository
        self.userRepository = userRepository
        self.searchRepository = searchRepository
        self.wishlistRepository = wishlistRepository
        self.analyticsClient = analyticsClient
        self.featureFlagClient = featureFlagClient
    }

    /// The active container used throughout the app.
    /// Set this once at app launch (e.g., in AppDelegate).
    static var current: ServiceContainer = .mock

    static let mock = ServiceContainer(
        productRepository: MockProductRepository(),
        cartRepository: MockCartRepository(),
        orderRepository: MockOrderRepository(),
        authRepository: MockAuthRepository(),
        userRepository: MockUserRepository(),
        searchRepository: MockSearchRepository(),
        wishlistRepository: MockWishlistRepository(),
        analyticsClient: .noop,
        featureFlagClient: .live
    )

    static let live = ServiceContainer(
        productRepository: LiveProductRepository(),
        cartRepository: LiveCartRepository(),
        orderRepository: LiveOrderRepository(),
        authRepository: LiveAuthRepository(),
        userRepository: LiveUserRepository(),
        searchRepository: MockSearchRepository(), // Replace with LiveSearchRepository when available
        wishlistRepository: MockWishlistRepository(), // Replace with LiveWishlistRepository when available
        analyticsClient: .live,
        featureFlagClient: .live
    )
}
