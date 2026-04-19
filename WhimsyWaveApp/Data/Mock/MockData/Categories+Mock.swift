import Foundation

extension Category {
    static let mockFurniture = Category(id: "CAT-001", name: "Furniture", image: "sofa.fill", productCount: 2450, subcategories: [
        Category(id: "CAT-001-1", name: "Living Room", image: "sofa.fill", productCount: 850, parentId: "CAT-001"),
        Category(id: "CAT-001-2", name: "Bedroom", image: "bed.double.fill", productCount: 620, parentId: "CAT-001"),
        Category(id: "CAT-001-3", name: "Dining Room", image: "fork.knife", productCount: 430, parentId: "CAT-001"),
        Category(id: "CAT-001-4", name: "Office", image: "desktopcomputer", productCount: 350, parentId: "CAT-001"),
        Category(id: "CAT-001-5", name: "Kitchen", image: "refrigerator.fill", productCount: 200, parentId: "CAT-001")
    ])

    static let mockLighting = Category(id: "CAT-002", name: "Lighting", image: "lamp.desk.fill", productCount: 1230)
    static let mockBath = Category(id: "CAT-003", name: "Bath", image: "bathtub.fill", productCount: 890)
    static let mockDecor = Category(id: "CAT-004", name: "Decor", image: "photo.artframe", productCount: 3200)
    static let mockOutdoor = Category(id: "CAT-005", name: "Outdoor", image: "leaf.fill", productCount: 1560)
    static let mockBedding = Category(id: "CAT-006", name: "Bedding", image: "bed.double.fill", productCount: 980)
    static let mockRugs = Category(id: "CAT-007", name: "Rugs", image: "square.grid.3x3.fill", productCount: 720)
    static let mockKitchen = Category(id: "CAT-008", name: "Kitchen", image: "fork.knife", productCount: 1450)
    static let mockSmartHome = Category(id: "CAT-009", name: "Smart Home", image: "homekit", productCount: 340)
    static let mockStorage = Category(id: "CAT-010", name: "Storage", image: "archivebox.fill", productCount: 670)

    static let mockCategories: [Category] = [
        .mockFurniture, .mockLighting, .mockBath, .mockDecor, .mockOutdoor,
        .mockBedding, .mockRugs, .mockKitchen, .mockSmartHome, .mockStorage
    ]
}
