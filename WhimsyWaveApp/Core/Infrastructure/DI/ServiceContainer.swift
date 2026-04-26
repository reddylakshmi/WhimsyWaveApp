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

    // Offline-first data layer
    let sqliteStore: SQLiteStore
    let dataRepository: DataRepository
    let ingestionWorker: DataIngestionWorker

    init(
        productRepository: IProductRepository,
        cartRepository: ICartRepository,
        orderRepository: IOrderRepository,
        authRepository: IAuthRepository,
        userRepository: IUserRepository,
        searchRepository: ISearchRepository,
        wishlistRepository: IWishlistRepository,
        analyticsClient: AnalyticsClient,
        featureFlagClient: FeatureFlagClient,
        sqliteStore: SQLiteStore,
        dataRepository: DataRepository,
        ingestionWorker: DataIngestionWorker
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
        self.sqliteStore = sqliteStore
        self.dataRepository = dataRepository
        self.ingestionWorker = ingestionWorker
    }

    /// The active container used throughout the app.
    /// Set this once at app launch (e.g., in AppDelegate).
    static var current: ServiceContainer = .mock

    static let mock: ServiceContainer = {
        let store = SQLiteStore()
        let repo = BundledDataRepository()
        let worker = DataIngestionWorker(dataRepository: repo, sqliteStore: store)
        return ServiceContainer(
            productRepository: MockProductRepository(),
            cartRepository: MockCartRepository(),
            orderRepository: MockOrderRepository(),
            authRepository: MockAuthRepository(),
            userRepository: MockUserRepository(),
            searchRepository: MockSearchRepository(),
            wishlistRepository: MockWishlistRepository(),
            analyticsClient: .noop,
            featureFlagClient: .live,
            sqliteStore: store,
            dataRepository: repo,
            ingestionWorker: worker
        )
    }()

    static let live: ServiceContainer = {
        let store = SQLiteStore()
        let repo = CloudDataRepository()
        let worker = DataIngestionWorker(dataRepository: repo, sqliteStore: store)
        return ServiceContainer(
            productRepository: LiveProductRepository(),
            cartRepository: LiveCartRepository(),
            orderRepository: LiveOrderRepository(),
            authRepository: LiveAuthRepository(),
            userRepository: LiveUserRepository(),
            searchRepository: MockSearchRepository(),
            wishlistRepository: MockWishlistRepository(),
            analyticsClient: .live,
            featureFlagClient: .live,
            sqliteStore: store,
            dataRepository: repo,
            ingestionWorker: worker
        )
    }()
}
