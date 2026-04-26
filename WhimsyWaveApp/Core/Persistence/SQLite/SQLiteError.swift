import Foundation

nonisolated enum SQLiteError: Error, LocalizedError, Sendable {
    case databaseLocked
    case fileNotFound(String)
    case checksumMismatch
    case migrationFailed(String)
    case corruptData(String)
    case openFailed(Int32)
    case prepareFailed(String)
    case executionFailed(String)
    case unknown(Int32)

    var errorDescription: String? {
        switch self {
        case .databaseLocked:
            return "Database is currently locked by another operation"
        case .fileNotFound(let path):
            return "Assortment file not found: \(path)"
        case .checksumMismatch:
            return "Data integrity check failed: checksum mismatch"
        case .migrationFailed(let reason):
            return "Database migration failed: \(reason)"
        case .corruptData(let detail):
            return "Corrupt data encountered: \(detail)"
        case .openFailed(let code):
            return "Failed to open database (code: \(code))"
        case .prepareFailed(let sql):
            return "Failed to prepare statement: \(sql)"
        case .executionFailed(let detail):
            return "SQL execution failed: \(detail)"
        case .unknown(let code):
            return "Unknown SQLite error (code: \(code))"
        }
    }
}
