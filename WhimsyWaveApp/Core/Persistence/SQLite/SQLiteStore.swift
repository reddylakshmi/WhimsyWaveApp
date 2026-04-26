import Foundation

/// High-level actor providing typed read/write access to the SQLite database.
/// All operations are serialized through the actor's isolation.
actor SQLiteStore {
    private let connection: SQLiteConnection
    private var isInitialized = false

    private static let dbFileName = "whimsywave.sqlite"

    init() {
        let dbPath = SQLiteStore.databasePath()
        self.connection = SQLiteConnection(path: dbPath)
    }

    // MARK: - Lifecycle

    /// Opens the database and creates all tables if needed.
    func initialize() throws {
        guard !isInitialized else { return }
        try connection.open()
        for sql in SQLiteSchema.allCreateStatements {
            try connection.executeRaw(sql)
        }
        try connection.execute(
            "INSERT OR REPLACE INTO metadata (key, value) VALUES (?, ?);",
            params: [SQLiteSchema.MetadataKey.schemaVersion, "\(SQLiteSchema.schemaVersion)"]
        )
        isInitialized = true
    }

    /// Drops all tables and recreates them. Used on region switch.
    func wipeAndRecreate() throws {
        try connection.executeRaw(SQLiteSchema.dropAllTables)
        for sql in SQLiteSchema.allCreateStatements {
            try connection.executeRaw(sql)
        }
    }

    // MARK: - Product Operations

    func ingestProducts(_ products: [Product], regionLocale: RegionLocale) throws {
        let sql = SQLiteMapper.productInsertSQL()
        try connection.inTransaction {
            for product in products {
                let params = SQLiteMapper.productParams(product, regionLocale: regionLocale)
                try self.connection.execute(sql, params: params)
            }
        }
    }

    func fetchProducts(regionLocale: RegionLocale, page: Int = 1, pageSize: Int = 20) throws -> [Product] {
        let offset = (page - 1) * pageSize
        let sql = "SELECT * FROM products WHERE region_locale = ? ORDER BY created_at DESC LIMIT ? OFFSET ?;"
        return try connection.query(sql, params: [regionLocale.key, pageSize, offset]) { stmt in
            SQLiteMapper.productFromRow(stmt)
        }.compactMap { $0 }
    }

    func fetchProduct(id: String, regionLocale: RegionLocale) throws -> Product? {
        let sql = "SELECT * FROM products WHERE id = ? AND region_locale = ?;"
        return try connection.queryOne(sql, params: [id, regionLocale.key]) { stmt in
            SQLiteMapper.productFromRow(stmt)
        } ?? nil
    }

    func fetchFeaturedProducts(regionLocale: RegionLocale) throws -> [Product] {
        let sql = "SELECT * FROM products WHERE region_locale = ? AND is_featured = 1 ORDER BY created_at DESC;"
        return try connection.query(sql, params: [regionLocale.key]) { stmt in
            SQLiteMapper.productFromRow(stmt)
        }.compactMap { $0 }
    }

    func fetchProductsByCategory(categoryId: String, regionLocale: RegionLocale, page: Int = 1, pageSize: Int = 20) throws -> [Product] {
        let offset = (page - 1) * pageSize
        let sql = "SELECT * FROM products WHERE region_locale = ? AND category_json LIKE ? ORDER BY created_at DESC LIMIT ? OFFSET ?;"
        let categoryPattern = "%\(categoryId)%"
        return try connection.query(sql, params: [regionLocale.key, categoryPattern, pageSize, offset]) { stmt in
            SQLiteMapper.productFromRow(stmt)
        }.compactMap { $0 }
    }

    /// Fetches products whose top-level category name matches. Uses JSON string matching
    /// since category_json is stored as `{"path":["CategoryName",...]}`.
    func fetchProductsByCategoryName(categoryName: String, regionLocale: RegionLocale, page: Int = 1, pageSize: Int = 20) throws -> [Product] {
        let offset = (page - 1) * pageSize
        let sql = "SELECT * FROM products WHERE region_locale = ? AND category_json LIKE ? ORDER BY created_at DESC LIMIT ? OFFSET ?;"
        // Match exact quoted name in JSON — "Furniture" won't match "Patio Furniture" because the quote is before "Patio"
        let pattern = "%\"\(categoryName)\"%"
        return try connection.query(sql, params: [regionLocale.key, pattern, pageSize, offset]) { stmt in
            SQLiteMapper.productFromRow(stmt)
        }.compactMap { $0 }
    }

    func fetchProductsByIds(_ ids: [String], regionLocale: RegionLocale) throws -> [Product] {
        guard !ids.isEmpty else { return [] }
        let placeholders = ids.map { _ in "?" }.joined(separator: ", ")
        let sql = "SELECT * FROM products WHERE region_locale = ? AND id IN (\(placeholders));"
        var params: [SQLiteBindable] = [regionLocale.key]
        params.append(contentsOf: ids)
        let products = try connection.query(sql, params: params) { stmt in
            SQLiteMapper.productFromRow(stmt)
        }.compactMap { $0 }
        // Preserve the original ordering from the ids array
        let productMap = Dictionary(uniqueKeysWithValues: products.map { ($0.id, $0) })
        return ids.compactMap { productMap[$0] }
    }

    // MARK: - Category Operations

    func ingestCategories(_ categories: [Category], regionLocale: RegionLocale) throws {
        let sql = SQLiteMapper.categoryInsertSQL()
        try connection.inTransaction {
            for category in categories {
                let params = SQLiteMapper.categoryParams(category, regionLocale: regionLocale)
                try self.connection.execute(sql, params: params)
            }
        }
    }

    func fetchCategories(regionLocale: RegionLocale) throws -> [Category] {
        let sql = "SELECT * FROM categories WHERE region_locale = ? ORDER BY name;"
        return try connection.query(sql, params: [regionLocale.key]) { stmt in
            SQLiteMapper.categoryFromRow(stmt)
        }.compactMap { $0 }
    }

    func fetchCategory(id: String, regionLocale: RegionLocale) throws -> Category? {
        let sql = "SELECT * FROM categories WHERE id = ? AND region_locale = ?;"
        return try connection.queryOne(sql, params: [id, regionLocale.key]) { stmt in
            SQLiteMapper.categoryFromRow(stmt)
        } ?? nil
    }

    // MARK: - Banner Operations

    func ingestBanners(_ banners: [Banner], regionLocale: RegionLocale) throws {
        let sql = SQLiteMapper.bannerInsertSQL()
        try connection.inTransaction {
            for banner in banners {
                let params = SQLiteMapper.bannerParams(banner, regionLocale: regionLocale)
                try self.connection.execute(sql, params: params)
            }
        }
    }

    func fetchBanners(regionLocale: RegionLocale) throws -> [Banner] {
        let sql = "SELECT * FROM banners WHERE region_locale = ? ORDER BY title;"
        return try connection.query(sql, params: [regionLocale.key]) { stmt in
            SQLiteMapper.bannerFromRow(stmt)
        }
    }

    // MARK: - Home Section Operations

    func ingestHomeSections(_ sections: [HomeSectionPayload], regionLocale: RegionLocale) throws {
        let sql = SQLiteMapper.homeSectionInsertSQL()
        try connection.inTransaction {
            for section in sections {
                let params = SQLiteMapper.homeSectionParams(section, regionLocale: regionLocale)
                try self.connection.execute(sql, params: params)
            }
        }
    }

    func fetchHomeSectionPayloads(regionLocale: RegionLocale) throws -> [HomeSectionPayload] {
        let sql = "SELECT * FROM home_sections WHERE region_locale = ? ORDER BY sort_order;"
        return try connection.query(sql, params: [regionLocale.key]) { stmt in
            SQLiteMapper.homeSectionPayloadFromRow(stmt)
        }
    }

    // MARK: - Metadata

    func updateMetadata(key: String, value: String) throws {
        try connection.execute(
            "INSERT OR REPLACE INTO metadata (key, value) VALUES (?, ?);",
            params: [key, value]
        )
    }

    func getMetadata(key: String) throws -> String? {
        try connection.queryOne(
            "SELECT value FROM metadata WHERE key = ?;",
            params: [key]
        ) { stmt in
            stmt.columnText(at: 0)
        }
    }

    // MARK: - Helpers

    private nonisolated static func databasePath() -> String {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let appDir = appSupport.appendingPathComponent("WhimsyWave", isDirectory: true)
        try? FileManager.default.createDirectory(at: appDir, withIntermediateDirectories: true)
        return appDir.appendingPathComponent(dbFileName).path
    }
}
