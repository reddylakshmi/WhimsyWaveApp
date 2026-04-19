import Foundation

struct ProductImage: Equatable, Sendable, Codable {
    let url: String
    let alt: String
}

struct ProductSpec: Equatable, Sendable, Codable {
    let label: String
    let value: String
}

struct ProductVariant: Equatable, Identifiable, Sendable, Codable {
    let id: String
    let name: String
    let color: String?
    let size: String?
    let additionalPrice: Decimal
    let isInStock: Bool
}

struct DateRange: Equatable, Sendable, Codable {
    let earliest: Date
    let latest: Date
}

struct CategoryPath: Equatable, Sendable, Codable {
    let path: [String]

    var display: String {
        path.joined(separator: " > ")
    }
}

struct Product: Equatable, Identifiable, Sendable, Codable {
    let id: String
    let name: String
    let brand: String
    let description: String
    let price: Decimal
    let salePrice: Decimal?
    let currency: String
    let images: [ProductImage]
    let category: CategoryPath
    let rating: Double
    let reviewCount: Int
    let specs: [ProductSpec]
    let variants: [ProductVariant]
    let tags: [String]
    let isInStock: Bool
    let stockCount: Int?
    let estimatedDelivery: DateRange?
    let isFeatured: Bool
    let isNew: Bool
    let createdAt: Date

    var displayPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        return formatter.string(from: price as NSDecimalNumber) ?? "$\(price)"
    }

    var displaySalePrice: String? {
        guard let salePrice else { return nil }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        return formatter.string(from: salePrice as NSDecimalNumber)
    }

    var isOnSale: Bool {
        salePrice != nil
    }

    var discountPercentage: Int? {
        guard let salePrice, price > 0 else { return nil }
        let discount = ((price - salePrice) / price) * 100
        return Int(truncating: discount as NSDecimalNumber)
    }

    var effectivePrice: Decimal {
        salePrice ?? price
    }

    var primaryImage: String {
        images.first?.url ?? ""
    }

    var categoryIcon: String {
        let cat = category.path.first ?? ""
        switch cat {
        case "Furniture": return "sofa.fill"
        case "Lighting": return "lamp.desk.fill"
        case "Bath": return "bathtub.fill"
        case "Decor": return "photo.artframe"
        case "Outdoor": return "leaf.fill"
        case "Bedding": return "bed.double.fill"
        case "Rugs": return "square.grid.3x3.fill"
        case "Kitchen": return "fork.knife"
        case "Smart Home": return "homekit"
        case "Storage": return "archivebox.fill"
        default: return "bag.fill"
        }
    }
}
