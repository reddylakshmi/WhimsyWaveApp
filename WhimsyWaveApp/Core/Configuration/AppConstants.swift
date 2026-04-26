import Foundation

enum AppConstants {

    enum Pagination {
        static let defaultPageSize = AppConfiguration.current.defaultPageSize
        static let prefetchThreshold = 3
    }

    enum Cache {
        static let imageCacheCountLimit = 200
        static let imageCacheMBLimit = 100
    }

    enum Animation {
        static let defaultDuration: Double = 0.3
        static let springResponse: Double = 0.4
        static let springDamping: Double = 0.75
        static let toastDisplayDuration: Double = 2.5
    }

    enum Retry {
        static let maxAttempts = 3
        static let baseDelaySeconds: Double = 1.0
    }

    enum Cart {
        static let maxItems = AppConfiguration.current.maxCartItems
        static let maxQuantityPerItem = 10
    }

    enum Search {
        static let debounceMilliseconds = 300
        static let minQueryLength = 2
        static let maxRecentSearches = 10
        static let maxSuggestions = 8
    }

    enum Image {
        static let thumbnailSize: CGFloat = 80
        static let productDetailSize: CGFloat = 400
        static let bannerHeight: CGFloat = 200
        static let avatarSize: CGFloat = 60
    }

    enum Layout {
        static let cornerRadius: CGFloat = 12
        static let cardCornerRadius: CGFloat = 16
        static let buttonCornerRadius: CGFloat = 10
        static let minTapTarget: CGFloat = 44
        static let gridColumnCount = 2
    }

    enum Session {
        static let timeoutMinutes = AppConfiguration.current.sessionTimeoutMinutes
    }

    enum Currency {
        static let code = "USD"
    }

    enum Shipping {
        static let standardCost = Decimal.zero
        static let expeditedCost = Decimal(string: "14.99")!
        static let expressCost = Decimal(string: "29.99")!
        static let freeShippingThreshold: Decimal = 49
        static let standardShippingCost = Decimal(string: "9.99")!
    }

    enum Tax {
        static let rate = Decimal(string: "0.0825")!
    }

    enum Order {
        static let numberPrefix = "HF-2026-"
    }

    enum Storage {
        static let maxImageCacheMB = 200
        static let sqliteWALCheckpointInterval = 50
        static let databaseFileName = "whimsywave.sqlite"
    }

    enum DataIngestion {
        static let defaultTimeoutSeconds: Double = 30
        static let maxRetryAttempts = 3
    }
}
