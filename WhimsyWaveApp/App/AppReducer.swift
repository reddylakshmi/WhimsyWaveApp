import Foundation
import Observation

@Observable @MainActor
final class AppReducer {
    // Feature instances
    let homeFeature = HomeFeature()
    let browseFeature = BrowseFeature()
    let searchFeature = SearchFeature()
    let cartFeature = CartFeature()
    let ordersFeature = OrdersFeature()
    let wishlistFeature = WishlistFeature()
    let profileFeature = ProfileFeature()
    let notificationsFeature = NotificationsFeature()
    let arFeature = ARFeature()

    // Navigation
    var selectedTab: Tab = .home
    var showingCheckout = false
    var showingProductDetail: Product?
    var showingLogin = false
    var showingSearch = false
    var showingNotifications = false
    var showingOrders = false
    var deepLink: DeepLink?

    // Tracks what to do after successful login
    var pendingAuthAction: PendingAuthAction?

    enum Tab: String, CaseIterable {
        case home, browse, cart, wishlist, profile

        var title: String {
            rawValue.capitalized
        }

        var icon: String {
            switch self {
            case .home: return "house"
            case .browse: return "square.grid.2x2"
            case .cart: return "cart"
            case .wishlist: return "heart"
            case .profile: return "person"
            }
        }
    }

    enum PendingAuthAction {
        case checkout
        case wishlist
    }

    /// Call before any auth-required action. Returns true if already authenticated.
    func requireAuth(for action: PendingAuthAction) -> Bool {
        if profileFeature.isAuthenticated {
            return true
        }
        pendingAuthAction = action
        showingLogin = true
        return false
    }

    /// Called after successful login to resume the pending action
    func handleLoginSuccess() {
        showingLogin = false
        guard let action = pendingAuthAction else { return }
        pendingAuthAction = nil

        switch action {
        case .checkout:
            showingCheckout = true
        case .wishlist:
            break
        }
    }

    func handleDeepLink(_ link: DeepLink) {
        switch link {
        case .home:
            selectedTab = .home
        case .product(let id):
            Task {
                let feature = ProductDetailFeature()
                await feature.loadProduct(id: id)
                showingProductDetail = feature.product
            }
        case .cart:
            selectedTab = .cart
        case .order:
            selectedTab = .profile
            showingOrders = true
        case .wishlist:
            selectedTab = .wishlist
        case .profile:
            selectedTab = .profile
        case .search(let query):
            selectedTab = .home
            searchFeature.query = query
            Task { await searchFeature.search() }
        default:
            break
        }
    }
}
