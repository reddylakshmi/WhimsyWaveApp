import Foundation

/// Protocol for fetching regionalized assortment data.
/// Implementations provide data from bundled JSON files or cloud sources.
nonisolated protocol DataRepository: Sendable {
    /// Fetches the complete assortment payload for a given region-locale.
    /// Returns raw data alongside the decoded payload for checksum validation.
    func fetchAssortment(for regionLocale: RegionLocale) async throws -> AssortmentPayload
}
