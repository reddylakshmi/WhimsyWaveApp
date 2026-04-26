import Foundation

nonisolated enum SQLiteSchema {

    static let schemaVersion = 1

    static let enableWAL = "PRAGMA journal_mode=WAL;"

    static let createMetadataTable = """
        CREATE TABLE IF NOT EXISTS metadata (
            key TEXT PRIMARY KEY NOT NULL,
            value TEXT NOT NULL
        );
        """

    static let createProductsTable = """
        CREATE TABLE IF NOT EXISTS products (
            id TEXT NOT NULL,
            region_locale TEXT NOT NULL,
            name TEXT NOT NULL,
            brand TEXT NOT NULL,
            description TEXT NOT NULL,
            price TEXT NOT NULL,
            sale_price TEXT,
            currency TEXT NOT NULL,
            images_json TEXT NOT NULL,
            category_json TEXT NOT NULL,
            rating REAL NOT NULL,
            review_count INTEGER NOT NULL,
            specs_json TEXT NOT NULL,
            variants_json TEXT NOT NULL,
            tags_json TEXT NOT NULL,
            is_in_stock INTEGER NOT NULL,
            stock_count INTEGER,
            estimated_delivery_json TEXT,
            is_featured INTEGER NOT NULL,
            is_new INTEGER NOT NULL,
            created_at REAL NOT NULL,
            PRIMARY KEY (id, region_locale)
        );
        """

    static let createCategoriesTable = """
        CREATE TABLE IF NOT EXISTS categories (
            id TEXT NOT NULL,
            region_locale TEXT NOT NULL,
            name TEXT NOT NULL,
            image TEXT NOT NULL,
            product_count INTEGER NOT NULL,
            subcategories_json TEXT NOT NULL,
            parent_id TEXT,
            PRIMARY KEY (id, region_locale)
        );
        """

    static let createBannersTable = """
        CREATE TABLE IF NOT EXISTS banners (
            id TEXT NOT NULL,
            region_locale TEXT NOT NULL,
            title TEXT NOT NULL,
            subtitle TEXT NOT NULL,
            image_url TEXT NOT NULL,
            background_color TEXT,
            deep_link TEXT,
            expires_at REAL,
            PRIMARY KEY (id, region_locale)
        );
        """

    static let createHomeSectionsTable = """
        CREATE TABLE IF NOT EXISTS home_sections (
            id TEXT NOT NULL,
            region_locale TEXT NOT NULL,
            type TEXT NOT NULL,
            title TEXT NOT NULL,
            subtitle TEXT,
            product_ids_json TEXT NOT NULL,
            category_ids_json TEXT NOT NULL,
            banner_ids_json TEXT NOT NULL,
            sort_order INTEGER NOT NULL,
            PRIMARY KEY (id, region_locale)
        );
        """

    static let allCreateStatements: [String] = [
        enableWAL,
        createMetadataTable,
        createProductsTable,
        createCategoriesTable,
        createBannersTable,
        createHomeSectionsTable
    ]

    static let dropAllTables = """
        DROP TABLE IF EXISTS home_sections;
        DROP TABLE IF EXISTS banners;
        DROP TABLE IF EXISTS categories;
        DROP TABLE IF EXISTS products;
        DROP TABLE IF EXISTS metadata;
        """

    // MARK: - Metadata Keys

    enum MetadataKey {
        static let currentRegionLocale = "current_region_locale"
        static let versionTag = "version_tag"
        static let lastUpdatedTimestamp = "last_updated_timestamp"
        static let schemaVersion = "schema_version"
    }
}
