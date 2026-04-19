import Foundation

enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum APIError: Error, Equatable, Sendable {
    case invalidURL
    case requestFailed(statusCode: Int)
    case decodingFailed
    case noData
    case unauthorized
    case forbidden
    case notFound
    case serverError
    case networkUnavailable
    case timeout
    case unknown(String)

    var userFacingMessage: String {
        switch self {
        case .networkUnavailable:
            return "No internet connection. Please check your network."
        case .timeout:
            return "Request timed out. Please try again."
        case .unauthorized:
            return "Session expired. Please log in again."
        case .serverError:
            return "Something went wrong. Please try again later."
        case .notFound:
            return "The requested content was not found."
        default:
            return "An unexpected error occurred."
        }
    }
}

enum ServiceType: Sendable {
    case product
    case cart
    case order
    case user
    case auth
    case search

    func baseURL(from config: AppConfiguration = .current) -> URL {
        switch self {
        case .product: return config.serviceURLs.product
        case .cart: return config.serviceURLs.cart
        case .order: return config.serviceURLs.order
        case .user: return config.serviceURLs.user
        case .auth: return config.serviceURLs.auth
        case .search: return config.serviceURLs.search
        }
    }
}

enum APIEndpoint: Sendable {
    case homeContent
    case categories
    case categoryProducts(id: String, page: Int)
    case productDetail(id: String)
    case searchProducts(query: String, page: Int)
    case cart(userId: String)
    case addToCart(userId: String)
    case updateCartItem(userId: String, productId: String)
    case removeCartItem(userId: String, productId: String)
    case checkout
    case orders(userId: String)
    case orderDetail(id: String)
    case userProfile(id: String)
    case updateProfile(id: String)
    case addAddress(userId: String)
    case updateAddress(userId: String, addressId: String)
    case deleteAddress(userId: String, addressId: String)
    case addPaymentMethod(userId: String)
    case deletePaymentMethod(userId: String, methodId: String)
    case wishlist(userId: String)
    case addToWishlist(userId: String)
    case removeFromWishlist(userId: String, productId: String)
    case reviews(productId: String, page: Int)
    case cancelOrder(id: String)
    case clearCart(userId: String)
    case login
    case register
    case refreshToken

    var service: ServiceType {
        switch self {
        case .homeContent, .categories, .categoryProducts, .productDetail, .reviews:
            return .product
        case .searchProducts:
            return .search
        case .cart, .addToCart, .updateCartItem, .removeCartItem, .clearCart, .checkout:
            return .cart
        case .orders, .orderDetail, .cancelOrder:
            return .order
        case .userProfile, .updateProfile, .addAddress, .updateAddress, .deleteAddress,
             .addPaymentMethod, .deletePaymentMethod, .wishlist, .addToWishlist, .removeFromWishlist:
            return .user
        case .login, .register, .refreshToken:
            return .auth
        }
    }

    var path: String {
        switch self {
        case .homeContent: return "/home"
        case .categories: return "/categories"
        case .categoryProducts(let id, _): return "/categories/\(id)/products"
        case .productDetail(let id): return "/products/\(id)"
        case .searchProducts: return "/products/search"
        case .cart(let userId): return "/users/\(userId)/cart"
        case .addToCart(let userId): return "/users/\(userId)/cart"
        case .updateCartItem(let userId, let productId): return "/users/\(userId)/cart/\(productId)"
        case .removeCartItem(let userId, let productId): return "/users/\(userId)/cart/\(productId)"
        case .checkout: return "/checkout"
        case .orders(let userId): return "/users/\(userId)/orders"
        case .orderDetail(let id): return "/orders/\(id)"
        case .userProfile(let id): return "/users/\(id)"
        case .updateProfile(let id): return "/users/\(id)"
        case .addAddress(let userId): return "/users/\(userId)/addresses"
        case .updateAddress(let userId, let addressId): return "/users/\(userId)/addresses/\(addressId)"
        case .deleteAddress(let userId, let addressId): return "/users/\(userId)/addresses/\(addressId)"
        case .addPaymentMethod(let userId): return "/users/\(userId)/payment-methods"
        case .deletePaymentMethod(let userId, let methodId): return "/users/\(userId)/payment-methods/\(methodId)"
        case .wishlist(let userId): return "/users/\(userId)/wishlist"
        case .addToWishlist(let userId): return "/users/\(userId)/wishlist"
        case .removeFromWishlist(let userId, let productId): return "/users/\(userId)/wishlist/\(productId)"
        case .reviews(let productId, _): return "/products/\(productId)/reviews"
        case .cancelOrder(let id): return "/orders/\(id)/cancel"
        case .clearCart(let userId): return "/users/\(userId)/cart"
        case .login: return "/auth/login"
        case .register: return "/auth/register"
        case .refreshToken: return "/auth/refresh"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .homeContent, .categories, .categoryProducts, .productDetail,
             .searchProducts, .cart, .orders, .orderDetail, .userProfile,
             .wishlist, .reviews:
            return .get
        case .addToCart, .checkout, .addToWishlist, .addAddress, .addPaymentMethod,
             .login, .register, .refreshToken, .cancelOrder:
            return .post
        case .updateCartItem, .updateProfile, .updateAddress:
            return .put
        case .removeCartItem, .removeFromWishlist, .deleteAddress, .deletePaymentMethod, .clearCart:
            return .delete
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .searchProducts(let query, let page):
            return [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "limit", value: "\(AppConstants.Pagination.defaultPageSize)")
            ]
        case .categoryProducts(_, let page):
            return [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "limit", value: "\(AppConstants.Pagination.defaultPageSize)")
            ]
        case .reviews(_, let page):
            return [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "limit", value: "\(AppConstants.Pagination.defaultPageSize)")
            ]
        default:
            return nil
        }
    }

    var requiresAuth: Bool {
        switch self {
        case .homeContent, .categories, .categoryProducts, .productDetail,
             .searchProducts, .reviews, .login, .register:
            return false
        default:
            return true
        }
    }
}

protocol APIClientProtocol: Sendable {
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
    func request<T: Decodable>(_ endpoint: APIEndpoint, body: Encodable & Sendable) async throws -> T
}

final class LiveAPIClient: APIClientProtocol, Sendable {
    private let config: AppConfiguration
    private let session: URLSession
    private let decoder: JSONDecoder

    init(
        config: AppConfiguration = .current,
        session: URLSession = .shared
    ) {
        self.config = config
        self.session = session

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = decoder
    }

    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        let request = try buildRequest(for: endpoint)
        return try await execute(request)
    }

    func request<T: Decodable>(_ endpoint: APIEndpoint, body: Encodable & Sendable) async throws -> T {
        var request = try buildRequest(for: endpoint)
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        request.httpBody = try encoder.encode(body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return try await execute(request)
    }

    private func buildRequest(for endpoint: APIEndpoint) throws -> URLRequest {
        let serviceBaseURL = endpoint.service.baseURL(from: config)
        var components = URLComponents(url: serviceBaseURL.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: true)
        components?.queryItems = endpoint.queryItems

        guard let url = components?.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = config.requestTimeoutSeconds

        if endpoint.requiresAuth {
            if let token = KeychainStore.load(for: .authToken) {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        }

        return request
    }

    private func execute<T: Decodable>(_ request: URLRequest) async throws -> T {
        var lastError: APIError = .unknown("No attempts made")

        for attempt in 1...AppConstants.Retry.maxAttempts {
            do {
                let (data, response) = try await session.data(for: request)

                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.unknown("Invalid response type")
                }

                switch httpResponse.statusCode {
                case 200...299:
                    return try decoder.decode(T.self, from: data)
                case 401:
                    throw APIError.unauthorized
                case 403:
                    throw APIError.forbidden
                case 404:
                    throw APIError.notFound
                case 500...599:
                    throw APIError.serverError
                default:
                    throw APIError.requestFailed(statusCode: httpResponse.statusCode)
                }
            } catch let error as APIError {
                if error == .unauthorized || error == .forbidden || error == .notFound {
                    throw error
                }
                lastError = error
                if attempt < AppConstants.Retry.maxAttempts {
                    let delay = AppConstants.Retry.baseDelaySeconds * pow(2.0, Double(attempt - 1))
                    try await Task.sleep(for: .seconds(delay))
                }
            } catch is DecodingError {
                throw APIError.decodingFailed
            } catch let urlError as URLError {
                if urlError.code == .timedOut {
                    lastError = .timeout
                } else if urlError.code == .notConnectedToInternet {
                    throw APIError.networkUnavailable
                } else {
                    lastError = .unknown(urlError.localizedDescription)
                }
                if attempt < AppConstants.Retry.maxAttempts {
                    let delay = AppConstants.Retry.baseDelaySeconds * pow(2.0, Double(attempt - 1))
                    try await Task.sleep(for: .seconds(delay))
                }
            }
        }

        throw lastError
    }
}
