import Foundation

enum DeepLink: Equatable, Sendable {
    case home
    case product(id: String)
    case category(id: String)
    case search(query: String)
    case cart
    case order(id: String)
    case profile
    case wishlist
    case settings
    case promotion(id: String)
}
