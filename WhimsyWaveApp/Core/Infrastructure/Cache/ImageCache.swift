import UIKit

final class ImageCache: @unchecked Sendable {
    static let shared = ImageCache()

    private let cache = NSCache<NSString, UIImage>()
    private let session: URLSession

    private init() {
        cache.countLimit = AppConstants.Cache.imageCacheCountLimit
        cache.totalCostLimit = AppConstants.Cache.imageCacheMBLimit * 1024 * 1024

        let config = URLSessionConfiguration.default
        config.urlCache = URLCache(
            memoryCapacity: 50 * 1024 * 1024,
            diskCapacity: 200 * 1024 * 1024
        )
        session = URLSession(configuration: config)
    }

    func image(for url: URL) async -> UIImage? {
        let key = url.absoluteString as NSString

        if let cached = cache.object(forKey: key) {
            return cached
        }

        do {
            let (data, _) = try await session.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            let cost = data.count
            cache.setObject(image, forKey: key, cost: cost)
            return image
        } catch {
            return nil
        }
    }
}
