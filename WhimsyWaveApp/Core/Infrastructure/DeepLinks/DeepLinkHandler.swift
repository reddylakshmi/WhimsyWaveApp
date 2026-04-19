import Foundation

enum DeepLinkHandler {

    static func parse(url: URL) -> DeepLink? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let host = components.host else {
            return nil
        }

        let pathComponents = components.path
            .split(separator: "/")
            .map(String.init)

        switch host {
        case "product":
            guard let id = pathComponents.first else { return nil }
            return .product(id: id)
        case "category":
            guard let id = pathComponents.first else { return nil }
            return .category(id: id)
        case "search":
            let query = components.queryItems?.first(where: { $0.name == "q" })?.value ?? ""
            return .search(query: query)
        case "cart":
            return .cart
        case "order":
            guard let id = pathComponents.first else { return nil }
            return .order(id: id)
        case "profile":
            return .profile
        case "wishlist":
            return .wishlist
        case "promotion":
            guard let id = pathComponents.first else { return nil }
            return .promotion(id: id)
        default:
            return .home
        }
    }

    static func parse(notificationUserInfo: [AnyHashable: Any]) -> DeepLink? {
        guard let type = notificationUserInfo["type"] as? String else { return nil }

        switch type {
        case "order_update":
            guard let id = notificationUserInfo["order_id"] as? String else { return nil }
            return .order(id: id)
        case "price_drop":
            guard let id = notificationUserInfo["product_id"] as? String else { return nil }
            return .product(id: id)
        case "promotion":
            guard let id = notificationUserInfo["promotion_id"] as? String else { return nil }
            return .promotion(id: id)
        case "cart_reminder":
            return .cart
        default:
            return nil
        }
    }
}
