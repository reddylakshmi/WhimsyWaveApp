import Foundation

struct AppConfiguration: Sendable {
    let environment: Environment
    let apiBaseURL: URL
    let imageBaseURL: URL
    let featureFlagURL: URL
    let analyticsKey: String
    let requestTimeoutSeconds: Double
    let defaultPageSize: Int
    let maxCartItems: Int
    let sessionTimeoutMinutes: Int
    let supportEmail: String
    let appStoreURL: URL
    let minimumAppVersion: String

    enum Environment: String, Sendable {
        case debug
        case staging
        case production

        var isDebug: Bool { self == .debug }
        var isProduction: Bool { self == .production }
    }

    static let current: AppConfiguration = .load()

    private static func load() -> AppConfiguration {
        let env = infoPlistValue(for: "ENVIRONMENT")
        let environment = Environment(rawValue: env) ?? .debug

        return AppConfiguration(
            environment: environment,
            apiBaseURL: url(for: "API_BASE_URL"),
            imageBaseURL: url(for: "IMAGE_BASE_URL"),
            featureFlagURL: url(for: "FEATURE_FLAG_URL"),
            analyticsKey: infoPlistValue(for: "ANALYTICS_KEY"),
            requestTimeoutSeconds: double(for: "REQUEST_TIMEOUT", default: 30),
            defaultPageSize: integer(for: "DEFAULT_PAGE_SIZE", default: 20),
            maxCartItems: integer(for: "MAX_CART_ITEMS", default: 50),
            sessionTimeoutMinutes: integer(for: "SESSION_TIMEOUT_MINUTES", default: 30),
            supportEmail: infoPlistValue(for: "SUPPORT_EMAIL"),
            appStoreURL: url(for: "APP_STORE_URL"),
            minimumAppVersion: infoPlistValue(for: "MINIMUM_APP_VERSION")
        )
    }

    private static func infoPlistValue(for key: String) -> String {
        guard let value = Bundle.main.infoDictionary?[key] as? String, !value.isEmpty else {
            return defaultValue(for: key)
        }
        return value
    }

    private static func url(for key: String) -> URL {
        let string = infoPlistValue(for: key)
        guard let url = URL(string: string) else {
            return URL(string: defaultValue(for: key))!
        }
        return url
    }

    private static func double(for key: String, default fallback: Double) -> Double {
        let string = infoPlistValue(for: key)
        return Double(string) ?? fallback
    }

    private static func integer(for key: String, default fallback: Int) -> Int {
        let string = infoPlistValue(for: key)
        return Int(string) ?? fallback
    }

    private static func defaultValue(for key: String) -> String {
        let defaults: [String: String] = [
            "ENVIRONMENT": "debug",
            "API_BASE_URL": "https://api.whimsywave.com/v1",
            "IMAGE_BASE_URL": "https://images.whimsywave.com",
            "FEATURE_FLAG_URL": "https://flags.whimsywave.com/v1",
            "ANALYTICS_KEY": "debug_analytics_key_2026",
            "REQUEST_TIMEOUT": "30",
            "DEFAULT_PAGE_SIZE": "20",
            "MAX_CART_ITEMS": "50",
            "SESSION_TIMEOUT_MINUTES": "30",
            "SUPPORT_EMAIL": "support@whimsywave.com",
            "APP_STORE_URL": "https://apps.apple.com/app/whimsy-wave/id123456789",
            "MINIMUM_APP_VERSION": "1.0.0"
        ]
        return defaults[key] ?? ""
    }
}
