import Foundation

enum ProductMapper {
    private static let dateFormatter: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        return f
    }()

    static func map(_ dto: ProductDTO) -> Product {
        Product(
            id: dto.id,
            name: dto.name,
            brand: dto.brand,
            description: dto.description,
            price: Decimal(dto.price),
            salePrice: dto.salePrice.map { Decimal($0) },
            currency: dto.currency,
            images: dto.images.map { ProductImage(url: $0.url, alt: $0.alt ?? "") },
            category: CategoryPath(path: dto.categoryPath),
            rating: dto.rating,
            reviewCount: dto.reviewCount,
            specs: (dto.specs ?? []).map { ProductSpec(label: $0.label, value: $0.value) },
            variants: (dto.variants ?? []).map { mapVariant($0) },
            tags: dto.tags ?? [],
            isInStock: dto.isInStock,
            stockCount: dto.stockCount,
            estimatedDelivery: mapDeliveryRange(earliest: dto.estimatedDeliveryEarliest, latest: dto.estimatedDeliveryLatest),
            isFeatured: dto.isFeatured,
            isNew: dto.isNew,
            createdAt: dateFormatter.date(from: dto.createdAt) ?? .now
        )
    }

    static func map(_ dtos: [ProductDTO]) -> [Product] {
        dtos.map { map($0) }
    }

    private static func mapVariant(_ dto: ProductVariantDTO) -> ProductVariant {
        ProductVariant(
            id: dto.id,
            name: dto.name,
            color: dto.color,
            size: dto.size,
            additionalPrice: Decimal(dto.additionalPrice),
            isInStock: dto.isInStock
        )
    }

    private static func mapDeliveryRange(earliest: String?, latest: String?) -> DateRange? {
        guard let e = earliest, let l = latest,
              let ed = dateFormatter.date(from: e),
              let ld = dateFormatter.date(from: l) else { return nil }
        return DateRange(earliest: ed, latest: ld)
    }
}
