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
    case wishlist(userId: String)
    case addToWishlist(userId: String)
    case removeFromWishlist(userId: String, productId: String)
    case reviews(productId: String, page: Int)
    case login
    case register
    case refreshToken

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
        case .wishlist(let userId): return "/users/\(userId)/wishlist"
        case .addToWishlist(let userId): return "/users/\(userId)/wishlist"
        case .removeFromWishlist(let userId, let productId): return "/users/\(userId)/wishlist/\(productId)"
        case .reviews(let productId, _): return "/products/\(productId)/reviews"
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
        case .addToCart, .checkout, .addToWishlist, .login, .register, .refreshToken:
            return .post
        case .updateCartItem, .updateProfile:
            return .put
        case .removeCartItem, .removeFromWishlist:
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
    private let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder

    init(
        baseURL: URL = AppConfiguration.current.apiBaseURL,
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
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
        var components = URLComponents(url: baseURL.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: true)
        components?.queryItems = endpoint.queryItems

        guard let url = components?.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = AppConfiguration.current.requestTimeoutSeconds

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
