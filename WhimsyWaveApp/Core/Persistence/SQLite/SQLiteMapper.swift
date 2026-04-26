import Foundation
import SQLite3

/// Maps between domain models and SQLite rows.
nonisolated enum SQLiteMapper {

    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()

    // MARK: - Product Mapping

    static func productInsertSQL() -> String {
        """
        INSERT OR REPLACE INTO products (
            id, region_locale, name, brand, description, price, sale_price,
            currency, images_json, category_json, rating, review_count,
            specs_json, variants_json, tags_json, is_in_stock, stock_count,
            estimated_delivery_json, is_featured, is_new, created_at
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
        """
    }

    static func productParams(_ product: Product, regionLocale: RegionLocale) -> [SQLiteBindable] {
        let imagesJSON = (try? encodeToString(product.images)) ?? "[]"
        let categoryJSON = (try? encodeToString(product.category)) ?? "{}"
        let specsJSON = (try? encodeToString(product.specs)) ?? "[]"
        let variantsJSON = (try? encodeToString(product.variants)) ?? "[]"
        let tagsJSON = (try? encodeToString(product.tags)) ?? "[]"
        let deliveryJSON: String? = product.estimatedDelivery.flatMap { try? encodeToString($0) }
        let salePriceStr: String? = product.salePrice.map { "\($0)" }

        return [
            product.id,
            regionLocale.key,
            product.name,
            product.brand,
            product.description,
            "\(product.price)",
            salePriceStr as SQLiteBindable,
            product.currency,
            imagesJSON,
            categoryJSON,
            product.rating,
            product.reviewCount,
            specsJSON,
            variantsJSON,
            tagsJSON,
            product.isInStock ? 1 : 0,
            product.stockCount as SQLiteBindable,
            deliveryJSON as SQLiteBindable,
            product.isFeatured ? 1 : 0,
            product.isNew ? 1 : 0,
            product.createdAt.timeIntervalSince1970
        ]
    }

    static func productFromRow(_ stmt: OpaquePointer) -> Product? {
        let priceStr = stmt.columnText(at: 5)
        guard let price = Decimal(string: priceStr) else { return nil }

        let salePriceStr = stmt.columnOptionalText(at: 6)
        let salePrice = salePriceStr.flatMap { Decimal(string: $0) }

        let images: [ProductImage] = decodeFromString(stmt.columnText(at: 8)) ?? []
        let category: CategoryPath = decodeFromString(stmt.columnText(at: 9)) ?? CategoryPath(path: [])
        let specs: [ProductSpec] = decodeFromString(stmt.columnText(at: 12)) ?? []
        let variants: [ProductVariant] = decodeFromString(stmt.columnText(at: 13)) ?? []
        let tags: [String] = decodeFromString(stmt.columnText(at: 14)) ?? []
        let deliveryJSON = stmt.columnOptionalText(at: 17)
        let delivery: DateRange? = deliveryJSON.flatMap { decodeFromString($0) }

        return Product(
            id: stmt.columnText(at: 0),
            name: stmt.columnText(at: 2),
            brand: stmt.columnText(at: 3),
            description: stmt.columnText(at: 4),
            price: price,
            salePrice: salePrice,
            currency: stmt.columnText(at: 7),
            images: images,
            category: category,
            rating: stmt.columnDouble(at: 10),
            reviewCount: stmt.columnInt(at: 11),
            specs: specs,
            variants: variants,
            tags: tags,
            isInStock: stmt.columnBool(at: 15),
            stockCount: stmt.columnOptionalInt(at: 16),
            estimatedDelivery: delivery,
            isFeatured: stmt.columnBool(at: 18),
            isNew: stmt.columnBool(at: 19),
            createdAt: Date(timeIntervalSince1970: stmt.columnDouble(at: 20))
        )
    }

    // MARK: - Category Mapping

    static func categoryInsertSQL() -> String {
        """
        INSERT OR REPLACE INTO categories (
            id, region_locale, name, image, product_count, subcategories_json, parent_id
        ) VALUES (?, ?, ?, ?, ?, ?, ?);
        """
    }

    static func categoryParams(_ category: Category, regionLocale: RegionLocale) -> [SQLiteBindable] {
        let subcategoriesJSON = (try? encodeToString(category.subcategories)) ?? "[]"
        return [
            category.id,
            regionLocale.key,
            category.name,
            category.image,
            category.productCount,
            subcategoriesJSON,
            category.parentId as SQLiteBindable
        ]
    }

    static func categoryFromRow(_ stmt: OpaquePointer) -> Category? {
        let subcategories: [Category] = decodeFromString(stmt.columnText(at: 5)) ?? []
        return Category(
            id: stmt.columnText(at: 0),
            name: stmt.columnText(at: 2),
            image: stmt.columnText(at: 3),
            productCount: stmt.columnInt(at: 4),
            subcategories: subcategories,
            parentId: stmt.columnOptionalText(at: 6)
        )
    }

    // MARK: - Banner Mapping

    static func bannerInsertSQL() -> String {
        """
        INSERT OR REPLACE INTO banners (
            id, region_locale, title, subtitle, image_url, background_color, deep_link, expires_at
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?);
        """
    }

    static func bannerParams(_ banner: Banner, regionLocale: RegionLocale) -> [SQLiteBindable] {
        return [
            banner.id,
            regionLocale.key,
            banner.title,
            banner.subtitle,
            banner.imageURL,
            banner.backgroundColor as SQLiteBindable,
            banner.deepLink as SQLiteBindable,
            banner.expiresAt.map { $0.timeIntervalSince1970 } as SQLiteBindable
        ]
    }

    static func bannerFromRow(_ stmt: OpaquePointer) -> Banner {
        let expiresAt = stmt.columnOptionalDouble(at: 7).map { Date(timeIntervalSince1970: $0) }
        return Banner(
            id: stmt.columnText(at: 0),
            title: stmt.columnText(at: 2),
            subtitle: stmt.columnText(at: 3),
            imageURL: stmt.columnText(at: 4),
            backgroundColor: stmt.columnOptionalText(at: 5),
            deepLink: stmt.columnOptionalText(at: 6),
            expiresAt: expiresAt
        )
    }

    // MARK: - Home Section Mapping

    static func homeSectionInsertSQL() -> String {
        """
        INSERT OR REPLACE INTO home_sections (
            id, region_locale, type, title, subtitle,
            product_ids_json, category_ids_json, banner_ids_json, sort_order
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);
        """
    }

    static func homeSectionParams(_ section: HomeSectionPayload, regionLocale: RegionLocale) -> [SQLiteBindable] {
        let productIdsJSON = (try? encodeToString(section.productIds)) ?? "[]"
        let categoryIdsJSON = (try? encodeToString(section.categoryIds)) ?? "[]"
        let bannerIdsJSON = (try? encodeToString(section.bannerIds)) ?? "[]"
        return [
            section.id,
            regionLocale.key,
            section.type,
            section.title,
            section.subtitle as SQLiteBindable,
            productIdsJSON,
            categoryIdsJSON,
            bannerIdsJSON,
            section.sortOrder
        ]
    }

    static func homeSectionPayloadFromRow(_ stmt: OpaquePointer) -> HomeSectionPayload {
        let productIds: [String] = decodeFromString(stmt.columnText(at: 5)) ?? []
        let categoryIds: [String] = decodeFromString(stmt.columnText(at: 6)) ?? []
        let bannerIds: [String] = decodeFromString(stmt.columnText(at: 7)) ?? []
        return HomeSectionPayload(
            id: stmt.columnText(at: 0),
            type: stmt.columnText(at: 2),
            title: stmt.columnText(at: 3),
            subtitle: stmt.columnOptionalText(at: 4),
            productIds: productIds,
            categoryIds: categoryIds,
            bannerIds: bannerIds,
            sortOrder: stmt.columnInt(at: 8)
        )
    }

    // MARK: - JSON Helpers

    private static func encodeToString<T: Encodable>(_ value: T) throws -> String {
        let data = try encoder.encode(value)
        return String(data: data, encoding: .utf8) ?? "null"
    }

    private static func decodeFromString<T: Decodable>(_ string: String) -> T? {
        guard let data = string.data(using: .utf8) else { return nil }
        return try? decoder.decode(T.self, from: data)
    }
}
