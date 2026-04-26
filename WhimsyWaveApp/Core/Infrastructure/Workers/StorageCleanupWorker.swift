import Foundation

/// Monitors app storage and cleans up cached assets when thresholds are exceeded.
/// Never deletes the SQLite database — only targets image cache and temporary files.
enum StorageCleanupWorker {

    private static let maxCacheSizeBytes: Int64 = Int64(AppConstants.Storage.maxImageCacheMB) * 1024 * 1024

    /// Performs cleanup of image cache if storage exceeds the configured threshold.
    static func performCleanupIfNeeded() {
        let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        guard let cacheDir else { return }

        let currentSize = directorySize(at: cacheDir)
        guard currentSize > maxCacheSizeBytes else { return }

        // Clear URLCache (shared URL session disk cache)
        URLCache.shared.removeAllCachedResponses()

        // Clear image cache temp files
        let tmpDir = cacheDir.appendingPathComponent("com.apple.nsurlsessiond", isDirectory: true)
        if FileManager.default.fileExists(atPath: tmpDir.path) {
            try? FileManager.default.removeItem(at: tmpDir)
        }
    }

    /// Calculates the total size of a directory in bytes.
    private static func directorySize(at url: URL) -> Int64 {
        let resourceKeys: Set<URLResourceKey> = [.fileSizeKey, .isDirectoryKey]
        guard let enumerator = FileManager.default.enumerator(
            at: url,
            includingPropertiesForKeys: Array(resourceKeys),
            options: [.skipsHiddenFiles]
        ) else { return 0 }

        var totalSize: Int64 = 0
        for case let fileURL as URL in enumerator {
            guard let values = try? fileURL.resourceValues(forKeys: resourceKeys),
                  let isDirectory = values.isDirectory,
                  !isDirectory,
                  let fileSize = values.fileSize else { continue }
            totalSize += Int64(fileSize)
        }
        return totalSize
    }
}
