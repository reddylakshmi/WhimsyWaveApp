import Foundation
import SQLite3

/// Low-level wrapper around the sqlite3 C API.
/// This class is NOT thread-safe on its own — it must only be accessed
/// from within the `SQLiteStore` actor's isolation context.
nonisolated final class SQLiteConnection: @unchecked Sendable {
    private var db: OpaquePointer?
    private let path: String

    nonisolated init(path: String) {
        self.path = path
    }

    // MARK: - Lifecycle

    func open() throws {
        let flags = SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE | SQLITE_OPEN_FULLMUTEX
        let result = sqlite3_open_v2(path, &db, flags, nil)
        guard result == SQLITE_OK else {
            throw SQLiteError.openFailed(result)
        }
        // Enable WAL mode for concurrent reads
        try executeRaw(SQLiteSchema.enableWAL)
    }

    func close() {
        if let db {
            sqlite3_close_v2(db)
        }
        db = nil
    }

    // MARK: - Execution

    /// Executes a raw SQL string (can contain multiple statements separated by semicolons).
    func executeRaw(_ sql: String) throws {
        guard let db else { throw SQLiteError.databaseLocked }
        var errorMessage: UnsafeMutablePointer<CChar>?
        let result = sqlite3_exec(db, sql, nil, nil, &errorMessage)
        if result != SQLITE_OK {
            let message = errorMessage.map { String(cString: $0) } ?? "Unknown error"
            sqlite3_free(errorMessage)
            if result == SQLITE_BUSY || result == SQLITE_LOCKED {
                throw SQLiteError.databaseLocked
            }
            throw SQLiteError.executionFailed(message)
        }
    }

    /// Prepares and executes a parameterized statement.
    func execute(_ sql: String, params: [SQLiteBindable] = []) throws {
        guard let db else { throw SQLiteError.databaseLocked }
        var stmt: OpaquePointer?
        guard sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK else {
            let msg = String(cString: sqlite3_errmsg(db))
            throw SQLiteError.prepareFailed("\(sql) — \(msg)")
        }
        defer { sqlite3_finalize(stmt) }

        for (index, param) in params.enumerated() {
            try param.bind(to: stmt!, at: Int32(index + 1))
        }

        let result = sqlite3_step(stmt)
        guard result == SQLITE_DONE || result == SQLITE_ROW else {
            let msg = String(cString: sqlite3_errmsg(db))
            if result == SQLITE_BUSY || result == SQLITE_LOCKED {
                throw SQLiteError.databaseLocked
            }
            throw SQLiteError.executionFailed(msg)
        }
    }

    /// Executes a query and maps each row using the provided closure.
    func query<T>(_ sql: String, params: [SQLiteBindable] = [], map: (OpaquePointer) -> T) throws -> [T] {
        guard let db else { throw SQLiteError.databaseLocked }
        var stmt: OpaquePointer?
        guard sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK else {
            let msg = String(cString: sqlite3_errmsg(db))
            throw SQLiteError.prepareFailed("\(sql) — \(msg)")
        }
        defer { sqlite3_finalize(stmt) }

        for (index, param) in params.enumerated() {
            try param.bind(to: stmt!, at: Int32(index + 1))
        }

        var results: [T] = []
        while sqlite3_step(stmt) == SQLITE_ROW {
            results.append(map(stmt!))
        }
        return results
    }

    /// Executes a query returning a single optional row.
    func queryOne<T>(_ sql: String, params: [SQLiteBindable] = [], map: (OpaquePointer) -> T) throws -> T? {
        let results = try query(sql, params: params, map: map)
        return results.first
    }

    /// Wraps a block of operations in a BEGIN/COMMIT transaction.
    /// Rolls back on error.
    func inTransaction(_ block: () throws -> Void) throws {
        try executeRaw("BEGIN IMMEDIATE;")
        do {
            try block()
            try executeRaw("COMMIT;")
        } catch {
            try? executeRaw("ROLLBACK;")
            throw error
        }
    }
}

// MARK: - SQLiteBindable Protocol

/// A value that can be bound to a sqlite3 prepared statement parameter.
nonisolated protocol SQLiteBindable: Sendable {
    func bind(to stmt: OpaquePointer, at index: Int32) throws
}

extension String: SQLiteBindable {
    nonisolated func bind(to stmt: OpaquePointer, at index: Int32) throws {
        let result = sqlite3_bind_text(stmt, index, self, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
        guard result == SQLITE_OK else {
            throw SQLiteError.executionFailed("Failed to bind String at index \(index)")
        }
    }
}

extension Int: SQLiteBindable {
    nonisolated func bind(to stmt: OpaquePointer, at index: Int32) throws {
        let result = sqlite3_bind_int64(stmt, index, Int64(self))
        guard result == SQLITE_OK else {
            throw SQLiteError.executionFailed("Failed to bind Int at index \(index)")
        }
    }
}

extension Double: SQLiteBindable {
    nonisolated func bind(to stmt: OpaquePointer, at index: Int32) throws {
        let result = sqlite3_bind_double(stmt, index, self)
        guard result == SQLITE_OK else {
            throw SQLiteError.executionFailed("Failed to bind Double at index \(index)")
        }
    }
}

extension Optional: SQLiteBindable where Wrapped: SQLiteBindable {
    nonisolated func bind(to stmt: OpaquePointer, at index: Int32) throws {
        switch self {
        case .some(let value):
            try value.bind(to: stmt, at: index)
        case .none:
            let result = sqlite3_bind_null(stmt, index)
            guard result == SQLITE_OK else {
                throw SQLiteError.executionFailed("Failed to bind null at index \(index)")
            }
        }
    }
}

// MARK: - Column Reading Helpers

nonisolated extension OpaquePointer {
    func columnText(at index: Int32) -> String {
        guard let cString = sqlite3_column_text(self, index) else { return "" }
        return String(cString: cString)
    }

    func columnOptionalText(at index: Int32) -> String? {
        guard sqlite3_column_type(self, index) != SQLITE_NULL else { return nil }
        guard let cString = sqlite3_column_text(self, index) else { return nil }
        return String(cString: cString)
    }

    func columnInt(at index: Int32) -> Int {
        Int(sqlite3_column_int64(self, index))
    }

    func columnOptionalInt(at index: Int32) -> Int? {
        guard sqlite3_column_type(self, index) != SQLITE_NULL else { return nil }
        return Int(sqlite3_column_int64(self, index))
    }

    func columnDouble(at index: Int32) -> Double {
        sqlite3_column_double(self, index)
    }

    func columnOptionalDouble(at index: Int32) -> Double? {
        guard sqlite3_column_type(self, index) != SQLITE_NULL else { return nil }
        return sqlite3_column_double(self, index)
    }

    func columnBool(at index: Int32) -> Bool {
        sqlite3_column_int(self, index) != 0
    }
}
