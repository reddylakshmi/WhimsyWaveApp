import Foundation

/// Minimal product fixtures for Cart+Mock and unit tests.
/// Full product catalog data lives in the bundled JSON assortment files.
extension Product {
    static let mockSofa = Product(
        id: "PRD-001", name: "Serta Convertible Sofa", brand: "Serta",
        description: "Versatile convertible sofa with memory foam cushions.",
        price: Decimal(string: "549.99")!, salePrice: Decimal(string: "439.99")!,
        currency: "USD",
        images: [ProductImage(url: "https://picsum.photos/seed/sofa/400/400", alt: "Sofa")],
        category: CategoryPath(path: ["Furniture", "Living Room", "Sofas"]),
        rating: 4.3, reviewCount: 2847,
        specs: [ProductSpec(label: "Material", value: "Performance Fabric")],
        variants: [], tags: ["furniture", "sofa"],
        isInStock: true, stockCount: 45, estimatedDelivery: nil,
        isFeatured: true, isNew: false, createdAt: Date(timeIntervalSince1970: 1700000000)
    )

    static let mockFloorLamp = Product(
        id: "PRD-003", name: "Brightech Sky LED Floor Lamp", brand: "Brightech",
        description: "Modern LED floor lamp with three color temperatures.",
        price: Decimal(string: "65.99")!, salePrice: nil,
        currency: "USD",
        images: [ProductImage(url: "https://picsum.photos/seed/lamp/400/400", alt: "Floor Lamp")],
        category: CategoryPath(path: ["Lighting", "Floor Lamps"]),
        rating: 4.6, reviewCount: 15234,
        specs: [ProductSpec(label: "Power", value: "30W LED")],
        variants: [], tags: ["lighting", "led"],
        isInStock: true, stockCount: 200, estimatedDelivery: nil,
        isFeatured: false, isNew: true, createdAt: Date(timeIntervalSince1970: 1700100000)
    )

    static let mockAreaRug = Product(
        id: "PRD-005", name: "nuLOOM Blythe Moroccan Rug", brand: "nuLOOM",
        description: "Moroccan-inspired area rug in polypropylene.",
        price: Decimal(string: "89.99")!, salePrice: Decimal(string: "67.49")!,
        currency: "USD",
        images: [ProductImage(url: "https://picsum.photos/seed/rug/400/400", alt: "Rug")],
        category: CategoryPath(path: ["Rugs", "Area Rugs"]),
        rating: 4.4, reviewCount: 8901,
        specs: [ProductSpec(label: "Size", value: "8' x 10'")],
        variants: [], tags: ["rugs"],
        isInStock: true, stockCount: 120, estimatedDelivery: nil,
        isFeatured: true, isNew: false, createdAt: Date(timeIntervalSince1970: 1700200000)
    )

    static let mockThrowBlanket = Product(
        id: "PRD-014", name: "Barefoot Dreams CozyChic Throw", brand: "Barefoot Dreams",
        description: "Ultra-soft microfiber throw blanket.",
        price: Decimal(string: "79.99")!, salePrice: nil,
        currency: "USD",
        images: [ProductImage(url: "https://picsum.photos/seed/throw/400/400", alt: "Throw Blanket")],
        category: CategoryPath(path: ["Bedding", "Throws & Blankets"]),
        rating: 4.8, reviewCount: 12456,
        specs: [ProductSpec(label: "Size", value: "54\" x 72\"")],
        variants: [], tags: ["bedding", "throw"],
        isInStock: true, stockCount: 300, estimatedDelivery: nil,
        isFeatured: false, isNew: false, createdAt: Date(timeIntervalSince1970: 1700300000)
    )
}
