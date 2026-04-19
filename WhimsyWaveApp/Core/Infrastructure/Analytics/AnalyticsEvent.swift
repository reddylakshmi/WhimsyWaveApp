import Foundation

enum ScreenName: String, Sendable {
    case home
    case browse
    case productDetail
    case search
    case cart
    case checkout
    case orders
    case orderDetail
    case wishlist
    case profile
    case settings
    case login
    case notifications
    case arTryOn
}

enum CheckoutStep: String, Sendable {
    case shippingAddress
    case deliveryOptions
    case payment
    case review
    case confirmation
}

struct UserProperties: Sendable, Equatable {
    let userId: String
    let email: String?
    let membershipTier: String?
}

enum AnalyticsEvent: Sendable {
    case productViewed(id: String, name: String, price: Decimal)
    case addedToCart(productId: String, quantity: Int)
    case removedFromCart(productId: String)
    case cartViewed(itemCount: Int, totalValue: Decimal)
    case checkoutStarted(cartValue: Decimal, itemCount: Int)
    case checkoutStepCompleted(step: CheckoutStep)
    case orderCompleted(orderId: String, total: Decimal)
    case searchPerformed(query: String, resultCount: Int)
    case filterApplied(filterType: String, value: String)
    case wishlistItemAdded(productId: String)
    case wishlistItemRemoved(productId: String)
    case notificationTapped(type: String, deepLink: String)
    case featureFlagExposed(flag: FeatureFlag, value: Bool)
    case appError(code: String, screen: ScreenName)
    case loginCompleted(method: String)
    case logoutCompleted
    case shareInitiated(productId: String, method: String)
}
