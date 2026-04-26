import Foundation

/// Stub implementation for future cloud-based assortment delivery (S3/CloudFront).
/// Currently falls back to bundled data.
final class CloudDataRepository: DataRepository, @unchecked Sendable {

    private let baseURL: URL
    private let bundledFallback: BundledDataRepository
    private let decoder: JSONDecoder

    init(baseURL: URL = URL(string: "https://cdn.whimsywave.com/assortments")!) {
        self.baseURL = baseURL
        self.bundledFallback = BundledDataRepository()
        self.decoder = JSONDecoder()
    }

    func fetchAssortment(for regionLocale: RegionLocale) async throws -> AssortmentPayload {
        // TODO: Implement cloud fetch with retry logic
        // For now, fall back to bundled data
        //
        // Future implementation:
        // 1. Download {baseURL}/{regionLocale}.json
        // 2. Validate SHA-256 checksum
        // 3. Return decoded payload
        // 4. On failure, fall back to bundledFallback

        return try await bundledFallback.fetchAssortment(for: regionLocale)
    }
}
