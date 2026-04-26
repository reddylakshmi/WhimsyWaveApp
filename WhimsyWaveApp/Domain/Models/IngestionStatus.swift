import Foundation

/// Represents the current state of data ingestion from assortment files into SQLite.
nonisolated enum IngestionStatus: Sendable {
    case idle
    case loading(progress: Double)
    case completed(timestamp: Date)
    case failed(Error)

    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    var isCompleted: Bool {
        if case .completed = self { return true }
        return false
    }

    var error: Error? {
        if case .failed(let error) = self { return error }
        return nil
    }
}
