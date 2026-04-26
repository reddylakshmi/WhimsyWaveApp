import Foundation

/// Off-main-thread actor responsible for fetching assortment data from
/// a `DataRepository` and ingesting it into the `SQLiteStore`.
actor DataIngestionWorker {
    private let dataRepository: DataRepository
    private let sqliteStore: SQLiteStore

    private var statusContinuation: AsyncStream<IngestionStatus>.Continuation?
    private(set) var currentStatus: IngestionStatus = .idle

    /// Stream of ingestion status updates for UI observation.
    lazy var statusStream: AsyncStream<IngestionStatus> = {
        AsyncStream { continuation in
            self.statusContinuation = continuation
        }
    }()

    init(dataRepository: DataRepository, sqliteStore: SQLiteStore) {
        self.dataRepository = dataRepository
        self.sqliteStore = sqliteStore
    }

    // MARK: - Public API

    /// Performs a full ingestion cycle: fetch → validate → wipe → ingest → update metadata.
    func ingestData(for regionLocale: RegionLocale) async throws {
        emitStatus(.loading(progress: 0.0))

        do {
            // Step 1: Fetch assortment from repository
            emitStatus(.loading(progress: 0.1))
            let payload = try await dataRepository.fetchAssortment(for: regionLocale)

            // Step 2: Wipe existing data for clean region switch
            emitStatus(.loading(progress: 0.3))
            try await sqliteStore.wipeAndRecreate()

            // Step 3: Ingest products
            emitStatus(.loading(progress: 0.4))
            try await sqliteStore.ingestProducts(payload.products, regionLocale: regionLocale)

            // Step 4: Ingest categories
            emitStatus(.loading(progress: 0.6))
            try await sqliteStore.ingestCategories(payload.categories, regionLocale: regionLocale)

            // Step 5: Ingest banners
            emitStatus(.loading(progress: 0.7))
            try await sqliteStore.ingestBanners(payload.banners, regionLocale: regionLocale)

            // Step 6: Ingest home sections
            emitStatus(.loading(progress: 0.8))
            try await sqliteStore.ingestHomeSections(payload.homeSections, regionLocale: regionLocale)

            // Step 7: Update metadata
            emitStatus(.loading(progress: 0.9))
            let now = Date()
            try await sqliteStore.updateMetadata(
                key: SQLiteSchema.MetadataKey.currentRegionLocale,
                value: regionLocale.key
            )
            try await sqliteStore.updateMetadata(
                key: SQLiteSchema.MetadataKey.versionTag,
                value: payload.version
            )
            try await sqliteStore.updateMetadata(
                key: SQLiteSchema.MetadataKey.lastUpdatedTimestamp,
                value: "\(now.timeIntervalSince1970)"
            )

            emitStatus(.completed(timestamp: now))

        } catch {
            // On error: do NOT wipe — preserve stale data for offline access
            emitStatus(.failed(error))
            throw error
        }
    }

    /// Handles a region change by resolving the locale and triggering ingestion.
    func handleRegionChange(to region: Region) async {
        let regionLocale = RegionLocale.resolve(from: region)
        do {
            try await ingestData(for: regionLocale)
        } catch {
            // Error already emitted via status stream
        }
    }

    /// Checks if the database needs initial ingestion (empty or stale).
    func performInitialIngestionIfNeeded(for region: Region) async {
        let regionLocale = RegionLocale.resolve(from: region)
        do {
            let stored = try await sqliteStore.getMetadata(key: SQLiteSchema.MetadataKey.currentRegionLocale)
            if stored == nil || stored != regionLocale.key {
                try await ingestData(for: regionLocale)
            }
        } catch {
            // Error already emitted via status stream
        }
    }

    // MARK: - Private

    private func emitStatus(_ status: IngestionStatus) {
        currentStatus = status
        statusContinuation?.yield(status)
    }
}
