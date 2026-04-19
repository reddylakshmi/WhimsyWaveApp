import Foundation

extension Product {
    // MARK: - Furniture

    static let mockSofa = Product(
        id: "PRD-001",
        name: "Serta Upholstered Convertible Sofa",
        brand: "Serta",
        description: "Transform your living space with this versatile convertible sofa. Features plush memory foam cushions, easy-convert mechanism, and durable performance fabric that resists stains and wear.",
        price: 899.99,
        salePrice: 649.99,
        currency: AppConstants.Currency.code,
        images: [.init(url: "https://picsum.photos/seed/sofa/600/600", alt: "Serta sofa front view"), .init(url: "https://picsum.photos/seed/sofa2/600/600", alt: "Serta sofa side view")],
        category: .init(path: ["Furniture", "Living Room", "Sofas"]),
        rating: 4.6,
        reviewCount: 1284,
        specs: [
            .init(label: "Dimensions", value: "84\"W x 36\"D x 34\"H"),
            .init(label: "Material", value: "Performance Fabric"),
            .init(label: "Weight Capacity", value: "600 lbs"),
            .init(label: "Assembly", value: "Required")
        ],
        variants: [
            .init(id: "V-001A", name: "Charcoal Gray", color: "Gray", size: nil, additionalPrice: 0, isInStock: true),
            .init(id: "V-001B", name: "Navy Blue", color: "Blue", size: nil, additionalPrice: 0, isInStock: true),
            .init(id: "V-001C", name: "Cream", color: "Cream", size: nil, additionalPrice: 50, isInStock: false)
        ],
        tags: ["bestseller", "free-shipping"],
        isInStock: true,
        stockCount: 23,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(3 * 86400), latest: Date().addingTimeInterval(7 * 86400)),
        isFeatured: true,
        isNew: false,
        createdAt: Date().addingTimeInterval(-30 * 86400)
    )

    static let mockDiningTable = Product(
        id: "PRD-002",
        name: "Walker Edison Rustic Farmhouse Dining Table",
        brand: "Walker Edison",
        description: "Bring warmth and character to your dining room with this solid wood farmhouse table. Hand-distressed finish gives each piece a unique look.",
        price: 499.99,
        salePrice: nil,
        currency: AppConstants.Currency.code,
        images: [.init(url: "https://picsum.photos/seed/diningtable/600/600", alt: "Farmhouse dining table")],
        category: .init(path: ["Furniture", "Dining Room", "Tables"]),
        rating: 4.3,
        reviewCount: 856,
        specs: [
            .init(label: "Dimensions", value: "72\"W x 36\"D x 30\"H"),
            .init(label: "Material", value: "Solid Pine Wood"),
            .init(label: "Seats", value: "6-8 people")
        ],
        variants: [],
        tags: ["eco-friendly"],
        isInStock: true,
        stockCount: 15,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(5 * 86400), latest: Date().addingTimeInterval(10 * 86400)),
        isFeatured: false,
        isNew: false,
        createdAt: Date().addingTimeInterval(-60 * 86400)
    )

    static let mockBedFrame = Product(
        id: "PRD-004",
        name: "Zinus Upholstered Platform Bed Frame",
        brand: "Zinus",
        description: "Sleep in style with this upholstered platform bed frame. No box spring needed. Tool-free assembly in under an hour.",
        price: 299.99,
        salePrice: nil,
        currency: AppConstants.Currency.code,
        images: [.init(url: "https://picsum.photos/seed/bedframe/600/600", alt: "Platform bed frame")],
        category: .init(path: ["Furniture", "Bedroom", "Beds"]),
        rating: 4.5,
        reviewCount: 3412,
        specs: [
            .init(label: "Size", value: "Queen"),
            .init(label: "Material", value: "Upholstered Fabric"),
            .init(label: "Weight Capacity", value: "700 lbs")
        ],
        variants: [
            .init(id: "V-004A", name: "Twin", color: nil, size: "Twin", additionalPrice: -100, isInStock: true),
            .init(id: "V-004B", name: "Queen", color: nil, size: "Queen", additionalPrice: 0, isInStock: true),
            .init(id: "V-004C", name: "King", color: nil, size: "King", additionalPrice: 100, isInStock: true)
        ],
        tags: ["bestseller"],
        isInStock: true,
        stockCount: 67,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(3 * 86400), latest: Date().addingTimeInterval(7 * 86400)),
        isFeatured: false,
        isNew: false,
        createdAt: Date().addingTimeInterval(-90 * 86400)
    )

    static let mockBarStools = Product(
        id: "PRD-006",
        name: "Christopher Knight Home Lopez Counter Stools (Set of 2)",
        brand: "Christopher Knight",
        description: "Elevate your kitchen island or bar with these sleek bonded leather counter stools. Sturdy iron legs with protective floor caps.",
        price: 159.99,
        salePrice: nil,
        currency: AppConstants.Currency.code,
        images: [.init(url: "https://picsum.photos/seed/barstools/600/600", alt: "Bar stools set")],
        category: .init(path: ["Furniture", "Kitchen", "Bar Stools"]),
        rating: 4.2,
        reviewCount: 923,
        specs: [
            .init(label: "Height", value: "26 inches (counter height)"),
            .init(label: "Material", value: "Bonded Leather & Iron"),
            .init(label: "Quantity", value: "Set of 2")
        ],
        variants: [
            .init(id: "V-006A", name: "Brown", color: "Brown", size: nil, additionalPrice: 0, isInStock: true),
            .init(id: "V-006B", name: "Black", color: "Black", size: nil, additionalPrice: 0, isInStock: true)
        ],
        tags: [],
        isInStock: true,
        stockCount: 45,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(4 * 86400), latest: Date().addingTimeInterval(8 * 86400)),
        isFeatured: false,
        isNew: true,
        createdAt: Date().addingTimeInterval(-5 * 86400)
    )

    static let mockDeskChair = Product(
        id: "PRD-011",
        name: "HON Ignition 2.0 Ergonomic Office Chair",
        brand: "HON",
        description: "Engineered for all-day comfort with advanced synchro-tilt recline and adjustable lumbar support. BIFMA certified for durability.",
        price: 459.99,
        salePrice: nil,
        currency: AppConstants.Currency.code,
        images: [.init(url: "https://picsum.photos/seed/officechair/600/600", alt: "Ergonomic office chair")],
        category: .init(path: ["Furniture", "Office", "Chairs"]),
        rating: 4.4,
        reviewCount: 2156,
        specs: [
            .init(label: "Weight Capacity", value: "300 lbs"),
            .init(label: "Adjustable Arms", value: "4D"),
            .init(label: "Warranty", value: "12 years")
        ],
        variants: [
            .init(id: "V-011A", name: "Black Mesh", color: "Black", size: nil, additionalPrice: 0, isInStock: true),
            .init(id: "V-011B", name: "Fog Mesh", color: "Gray", size: nil, additionalPrice: 0, isInStock: true)
        ],
        tags: ["bestseller"],
        isInStock: true,
        stockCount: 34,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(5 * 86400), latest: Date().addingTimeInterval(9 * 86400)),
        isFeatured: false,
        isNew: false,
        createdAt: Date().addingTimeInterval(-75 * 86400)
    )

    static let mockBookshelf = Product(
        id: "PRD-016",
        name: "VASAGLE Industrial Bookshelf 5-Tier",
        brand: "VASAGLE",
        description: "Open concept industrial bookshelf with rustic brown shelves and matte black metal frame. Perfect for living room, office, or bedroom.",
        price: 129.99,
        salePrice: 99.99,
        currency: AppConstants.Currency.code,
        images: [.init(url: "https://picsum.photos/seed/bookshelf/600/600", alt: "Industrial bookshelf")],
        category: .init(path: ["Furniture", "Living Room", "Shelving"]),
        rating: 4.5,
        reviewCount: 4230,
        specs: [
            .init(label: "Dimensions", value: "31.5\"W x 11.8\"D x 66.1\"H"),
            .init(label: "Material", value: "Particleboard & Steel"),
            .init(label: "Weight Capacity", value: "33 lbs per shelf")
        ],
        variants: [],
        tags: ["bestseller"],
        isInStock: true,
        stockCount: 112,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(2 * 86400), latest: Date().addingTimeInterval(5 * 86400)),
        isFeatured: true,
        isNew: false,
        createdAt: Date().addingTimeInterval(-50 * 86400)
    )

    static let mockSideTable = Product(
        id: "PRD-017",
        name: "Round Marble Top Side Table",
        brand: "Nathan James",
        description: "Elegant round side table with genuine marble top and gold metal base. A stunning accent piece for any room.",
        price: 89.99,
        salePrice: nil,
        currency: AppConstants.Currency.code,
        images: [.init(url: "https://picsum.photos/seed/sidetable/600/600", alt: "Marble side table")],
        category: .init(path: ["Furniture", "Living Room", "Side Tables"]),
        rating: 4.6,
        reviewCount: 1892,
        specs: [
            .init(label: "Top Diameter", value: "15 inches"),
            .init(label: "Height", value: "24 inches"),
            .init(label: "Material", value: "Marble & Gold Metal")
        ],
        variants: [],
        tags: ["trending"],
        isInStock: true,
        stockCount: 78,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(2 * 86400), latest: Date().addingTimeInterval(4 * 86400)),
        isFeatured: false,
        isNew: true,
        createdAt: Date().addingTimeInterval(-4 * 86400)
    )

    // MARK: - Lighting

    static let mockFloorLamp = Product(
        id: "PRD-003",
        name: "Brightech Sky LED Torchiere Floor Lamp",
        brand: "Brightech",
        description: "Illuminate any room with this sleek modern floor lamp. Features dimmable LED light with three color temperatures and a slim profile that fits anywhere.",
        price: 69.99,
        salePrice: 54.99,
        currency: AppConstants.Currency.code,
        images: [.init(url: "https://picsum.photos/seed/floorlamp/600/600", alt: "Floor lamp in living room")],
        category: .init(path: ["Lighting", "Floor Lamps"]),
        rating: 4.7,
        reviewCount: 2341,
        specs: [
            .init(label: "Height", value: "72 inches"),
            .init(label: "Wattage", value: "30W LED"),
            .init(label: "Color Temps", value: "3000K/4000K/5000K")
        ],
        variants: [
            .init(id: "V-003A", name: "Matte Black", color: "Black", size: nil, additionalPrice: 0, isInStock: true),
            .init(id: "V-003B", name: "Brushed Nickel", color: "Silver", size: nil, additionalPrice: 10, isInStock: true)
        ],
        tags: ["energy-efficient", "top-rated"],
        isInStock: true,
        stockCount: 142,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(2 * 86400), latest: Date().addingTimeInterval(4 * 86400)),
        isFeatured: true,
        isNew: false,
        createdAt: Date().addingTimeInterval(-45 * 86400)
    )

    static let mockPendantLight = Product(
        id: "PRD-018",
        name: "Globe Electric Harrow 1-Light Pendant",
        brand: "Globe Electric",
        description: "Modern matte black pendant light with exposed bulb design. Perfect over kitchen island, dining table, or entryway.",
        price: 49.99,
        salePrice: 39.99,
        currency: AppConstants.Currency.code,
        images: [.init(url: "https://picsum.photos/seed/pendantlight/600/600", alt: "Pendant light")],
        category: .init(path: ["Lighting", "Pendant Lights"]),
        rating: 4.4,
        reviewCount: 1567,
        specs: [
            .init(label: "Diameter", value: "10 inches"),
            .init(label: "Cord Length", value: "60 inches (adjustable)"),
            .init(label: "Bulb Type", value: "E26 (not included)")
        ],
        variants: [
            .init(id: "V-018A", name: "Matte Black", color: "Black", size: nil, additionalPrice: 0, isInStock: true),
            .init(id: "V-018B", name: "Brass", color: "Gold", size: nil, additionalPrice: 10, isInStock: true)
        ],
        tags: ["trending"],
        isInStock: true,
        stockCount: 210,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(1 * 86400), latest: Date().addingTimeInterval(3 * 86400)),
        isFeatured: false,
        isNew: true,
        createdAt: Date().addingTimeInterval(-8 * 86400)
    )

    static let mockTableLamp = Product(
        id: "PRD-019",
        name: "Lalia Home Sculpted Table Lamp",
        brand: "Lalia Home",
        description: "Elegant ceramic table lamp with linen drum shade. Adds warm ambient light and sophisticated style to nightstands or console tables.",
        price: 42.99,
        salePrice: nil,
        currency: AppConstants.Currency.code,
        images: [.init(url: "https://picsum.photos/seed/tablelamp/600/600", alt: "Table lamp")],
        category: .init(path: ["Lighting", "Table Lamps"]),
        rating: 4.3,
        reviewCount: 890,
        specs: [
            .init(label: "Height", value: "18.5 inches"),
            .init(label: "Shade", value: "10\" Linen Drum"),
            .init(label: "Material", value: "Ceramic & Linen")
        ],
        variants: [],
        tags: [],
        isInStock: true,
        stockCount: 156,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(1 * 86400), latest: Date().addingTimeInterval(3 * 86400)),
        isFeatured: false,
        isNew: false,
        createdAt: Date().addingTimeInterval(-65 * 86400)
    )

    // MARK: - Bath

    static let mockShowerHead = Product(
        id: "PRD-007",
        name: "Moen Magnetix Rainfall Shower Head",
        brand: "Moen",
        description: "Transform your daily shower with this rainfall shower head featuring magnetic docking system. Six spray settings for a customized experience.",
        price: 89.99,
        salePrice: 69.99,
        currency: AppConstants.Currency.code,
        images: [.init(url: "https://picsum.photos/seed/showerhead/600/600", alt: "Rainfall shower head")],
        category: .init(path: ["Bath", "Shower Heads"]),
        rating: 4.8,
        reviewCount: 4521,
        specs: [
            .init(label: "Diameter", value: "8 inches"),
            .init(label: "Spray Settings", value: "6"),
            .init(label: "Finish", value: "Chrome")
        ],
        variants: [],
        tags: ["top-rated", "bestseller"],
        isInStock: true,
        stockCount: 89,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(1 * 86400), latest: Date().addingTimeInterval(3 * 86400)),
        isFeatured: false,
        isNew: false,
        createdAt: Date().addingTimeInterval(-120 * 86400)
    )

    static let mockVanity = Product(
        id: "PRD-009",
        name: "Glacier Bay 36\" Bath Vanity with Top",
        brand: "Glacier Bay",
        description: "Complete bathroom vanity set with cultured marble top and pre-installed sink. Soft-close doors and full-extension drawers.",
        price: 549.99,
        salePrice: 449.99,
        currency: AppConstants.Currency.code,
        images: [.init(url: "https://picsum.photos/seed/vanity/600/600", alt: "Bathroom vanity")],
        category: .init(path: ["Bath", "Vanities"]),
        rating: 4.1,
        reviewCount: 567,
        specs: [
            .init(label: "Width", value: "36 inches"),
            .init(label: "Material", value: "Engineered Wood"),
            .init(label: "Top", value: "Cultured Marble")
        ],
        variants: [
            .init(id: "V-009A", name: "White", color: "White", size: nil, additionalPrice: 0, isInStock: true),
            .init(id: "V-009B", name: "Espresso", color: "Brown", size: nil, additionalPrice: 0, isInStock: true)
        ],
        tags: ["free-shipping"],
        isInStock: true,
        stockCount: 18,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(7 * 86400), latest: Date().addingTimeInterval(14 * 86400)),
        isFeatured: false,
        isNew: true,
        createdAt: Date().addingTimeInterval(-3 * 86400)
    )

    static let mockBathTowels = Product(
        id: "PRD-020",
        name: "Chakir Turkish Linens Hotel Collection Towel Set",
        brand: "Chakir",
        description: "Luxury 700 GSM Turkish cotton towels. Set of 6 includes 2 bath towels, 2 hand towels, and 2 washcloths. Ultra-absorbent and quick-drying.",
        price: 59.99,
        salePrice: 44.99,
        currency: AppConstants.Currency.code,
        images: [.init(url: "https://picsum.photos/seed/towels/600/600", alt: "Turkish towel set")],
        category: .init(path: ["Bath", "Towels"]),
        rating: 4.7,
        reviewCount: 6432,
        specs: [
            .init(label: "GSM", value: "700"),
            .init(label: "Material", value: "100% Turkish Cotton"),
            .init(label: "Set Includes", value: "6 pieces")
        ],
        variants: [
            .init(id: "V-020A", name: "White", color: "White", size: nil, additionalPrice: 0, isInStock: true),
            .init(id: "V-020B", name: "Navy", color: "Navy", size: nil, additionalPrice: 0, isInStock: true),
            .init(id: "V-020C", name: "Sage Green", color: "Green", size: nil, additionalPrice: 0, isInStock: true)
        ],
        tags: ["top-rated", "value-pack"],
        isInStock: true,
        stockCount: 340,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(1 * 86400), latest: Date().addingTimeInterval(3 * 86400)),
        isFeatured: true,
        isNew: false,
        createdAt: Date().addingTimeInterval(-35 * 86400)
    )

    // MARK: - Decor

    static let mockCurtains = Product(
        id: "PRD-008",
        name: "NICETOWN Thermal Insulated Blackout Curtains",
        brand: "NICETOWN",
        description: "Block out light and reduce noise with these thermal insulated blackout curtains. Triple weave technology for maximum energy efficiency.",
        price: 44.99,
        salePrice: nil,
        currency: AppConstants.Currency.code,
        images: [.init(url: "https://picsum.photos/seed/curtains/600/600", alt: "Blackout curtains")],
        category: .init(path: ["Decor", "Window Treatments", "Curtains"]),
        rating: 4.6,
        reviewCount: 7234,
        specs: [
            .init(label: "Size", value: "52\"W x 84\"L (pair)"),
            .init(label: "Material", value: "Triple Weave Polyester"),
            .init(label: "Hanging", value: "Grommet Top")
        ],
        variants: [
            .init(id: "V-008A", name: "Jet Black", color: "Black", size: nil, additionalPrice: 0, isInStock: true),
            .init(id: "V-008B", name: "Navy", color: "Navy", size: nil, additionalPrice: 0, isInStock: true),
            .init(id: "V-008C", name: "Burgundy", color: "Red", size: nil, additionalPrice: 0, isInStock: true),
            .init(id: "V-008D", name: "Stone Blue", color: "Blue", size: nil, additionalPrice: 0, isInStock: true)
        ],
        tags: ["energy-efficient"],
        isInStock: true,
        stockCount: 312,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(1 * 86400), latest: Date().addingTimeInterval(3 * 86400)),
        isFeatured: false,
        isNew: false,
        createdAt: Date().addingTimeInterval(-180 * 86400)
    )

    static let mockWallArt = Product(
        id: "PRD-010",
        name: "Pyradecor Large Abstract Canvas Wall Art",
        brand: "Pyradecor",
        description: "Modern abstract canvas art prints stretched and framed, ready to hang. High-definition giclee printing on premium canvas.",
        price: 79.99,
        salePrice: nil,
        currency: AppConstants.Currency.code,
        images: [.init(url: "https://picsum.photos/seed/wallart/600/600", alt: "Abstract canvas wall art")],
        category: .init(path: ["Decor", "Wall Art"]),
        rating: 4.5,
        reviewCount: 1892,
        specs: [
            .init(label: "Size", value: "60\"W x 30\"H (total)"),
            .init(label: "Panels", value: "5 pieces"),
            .init(label: "Material", value: "Canvas on Wood Frame")
        ],
        variants: [],
        tags: [],
        isInStock: true,
        stockCount: 76,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(3 * 86400), latest: Date().addingTimeInterval(6 * 86400)),
        isFeatured: true,
        isNew: false,
        createdAt: Date().addingTimeInterval(-15 * 86400)
    )

    static let mockMirror = Product(
        id: "PRD-021",
        name: "BEAUTYPEAK Arched Full-Length Mirror",
        brand: "BEAUTYPEAK",
        description: "Elegant arched full-length floor mirror with aluminum alloy frame. Lean against wall or hang. Shatterproof glass for safety.",
        price: 99.99,
        salePrice: 79.99,
        currency: AppConstants.Currency.code,
        images: [.init(url: "https://picsum.photos/seed/mirror/600/600", alt: "Arched floor mirror")],
        category: .init(path: ["Decor", "Mirrors"]),
        rating: 4.6,
        reviewCount: 3421,
        specs: [
            .init(label: "Size", value: "65\" x 22\""),
            .init(label: "Frame", value: "Aluminum Alloy"),
            .init(label: "Glass", value: "HD Shatterproof")
        ],
        variants: [
            .init(id: "V-021A", name: "Gold", color: "Gold", size: nil, additionalPrice: 0, isInStock: true),
            .init(id: "V-021B", name: "Black", color: "Black", size: nil, additionalPrice: 0, isInStock: true)
        ],
        tags: ["trending", "bestseller"],
        isInStock: true,
        stockCount: 95,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(3 * 86400), latest: Date().addingTimeInterval(6 * 86400)),
        isFeatured: true,
        isNew: false,
        createdAt: Date().addingTimeInterval(-12 * 86400)
    )

    static let mockThrowPillows = Product(
        id: "PRD-022",
        name: "MIULEE Velvet Throw Pillow Covers (Set of 4)",
        brand: "MIULEE",
        description: "Luxuriously soft velvet pillow covers in curated color combinations. Hidden zipper closure. Machine washable.",
        price: 22.99,
        salePrice: nil,
        currency: AppConstants.Currency.code,
        images: [.init(url: "https://picsum.photos/seed/throwpillows/600/600", alt: "Velvet pillow covers")],
        category: .init(path: ["Decor", "Pillows & Throws"]),
        rating: 4.5,
        reviewCount: 8932,
        specs: [
            .init(label: "Size", value: "18\" x 18\""),
            .init(label: "Material", value: "Velvet"),
            .init(label: "Quantity", value: "Set of 4 covers")
        ],
        variants: [],
        tags: ["value-pack"],
        isInStock: true,
        stockCount: 670,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(1 * 86400), latest: Date().addingTimeInterval(2 * 86400)),
        isFeatured: false,
        isNew: false,
        createdAt: Date().addingTimeInterval(-100 * 86400)
    )

    // MARK: - Outdoor

    static let mockPlanters = Product(
        id: "PRD-012",
        name: "Mkono Ceramic Plant Pots Set of 3",
        brand: "Mkono",
        description: "Modern minimalist ceramic planters with bamboo saucers. Drainage hole included for healthy plants. Three sizes for versatile display.",
        price: 34.99,
        salePrice: 27.99,
        currency: AppConstants.Currency.code,
        images: [.init(url: "https://picsum.photos/seed/planters/600/600", alt: "Ceramic plant pots")],
        category: .init(path: ["Outdoor", "Planters"]),
        rating: 4.7,
        reviewCount: 3456,
        specs: [
            .init(label: "Sizes", value: "4\", 5\", 6\" diameter"),
            .init(label: "Material", value: "Ceramic with Bamboo Saucer"),
            .init(label: "Drainage", value: "Yes")
        ],
        variants: [
            .init(id: "V-012A", name: "White", color: "White", size: nil, additionalPrice: 0, isInStock: true),
            .init(id: "V-012B", name: "Terracotta", color: "Orange", size: nil, additionalPrice: 3, isInStock: true)
        ],
        tags: ["top-rated"],
        isInStock: true,
        stockCount: 523,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(1 * 86400), latest: Date().addingTimeInterval(3 * 86400)),
        isFeatured: false,
        isNew: false,
        createdAt: Date().addingTimeInterval(-40 * 86400)
    )

    static let mockPatioSet = Product(
        id: "PRD-023",
        name: "UDPATIO 4-Piece Outdoor Conversation Set",
        brand: "UDPATIO",
        description: "Weather-resistant wicker patio furniture set includes loveseat, 2 chairs, and coffee table with tempered glass top. Quick-dry cushions included.",
        price: 449.99,
        salePrice: 349.99,
        currency: AppConstants.Currency.code,
        images: [.init(url: "https://picsum.photos/seed/patioset/600/600", alt: "Patio conversation set")],
        category: .init(path: ["Outdoor", "Patio Furniture"]),
        rating: 4.3,
        reviewCount: 2134,
        specs: [
            .init(label: "Material", value: "PE Rattan Wicker"),
            .init(label: "Cushion", value: "Olefin Fabric (removable)"),
            .init(label: "Frame", value: "Powder-Coated Steel")
        ],
        variants: [
            .init(id: "V-023A", name: "Dark Brown / Beige", color: "Brown", size: nil, additionalPrice: 0, isInStock: true),
            .init(id: "V-023B", name: "Gray / Blue", color: "Gray", size: nil, additionalPrice: 0, isInStock: true)
        ],
        tags: ["free-shipping"],
        isInStock: true,
        stockCount: 24,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(5 * 86400), latest: Date().addingTimeInterval(10 * 86400)),
        isFeatured: false,
        isNew: true,
        createdAt: Date().addingTimeInterval(-6 * 86400)
    )

    static let mockStringLights = Product(
        id: "PRD-024",
        name: "Brightown Waterproof LED String Lights 100ft",
        brand: "Brightown",
        description: "Create a magical outdoor ambiance with these warm white LED string lights. Shatterproof bulbs, waterproof for year-round use.",
        price: 35.99,
        salePrice: nil,
        currency: AppConstants.Currency.code,
        images: [.init(url: "https://picsum.photos/seed/stringlights/600/600", alt: "Outdoor string lights")],
        category: .init(path: ["Outdoor", "Outdoor Lighting"]),
        rating: 4.6,
        reviewCount: 5678,
        specs: [
            .init(label: "Length", value: "100 feet"),
            .init(label: "Bulbs", value: "50 LED (shatterproof)"),
            .init(label: "Rating", value: "IP65 Waterproof")
        ],
        variants: [],
        tags: ["top-rated"],
        isInStock: true,
        stockCount: 430,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(1 * 86400), latest: Date().addingTimeInterval(3 * 86400)),
        isFeatured: false,
        isNew: false,
        createdAt: Date().addingTimeInterval(-25 * 86400)
    )

    // MARK: - Bedding

    static let mockThrowBlanket = Product(
        id: "PRD-014",
        name: "Barefoot Dreams CozyChic Throw Blanket",
        brand: "Barefoot Dreams",
        description: "Ultra-soft microfiber throw blanket that gets softer with every wash. Machine washable luxury for your sofa or bed.",
        price: 147.00,
        salePrice: nil,
        currency: AppConstants.Currency.code,
        images: [.init(url: "https://picsum.photos/seed/blanket/600/600", alt: "Cozy throw blanket")],
        category: .init(path: ["Bedding", "Throws & Blankets"]),
        rating: 4.9,
        reviewCount: 8912,
        specs: [
            .init(label: "Size", value: "54\" x 72\""),
            .init(label: "Material", value: "Microfiber Polyester"),
            .init(label: "Care", value: "Machine Washable")
        ],
        variants: [
            .init(id: "V-014A", name: "Stone/Cream", color: "Beige", size: nil, additionalPrice: 0, isInStock: true),
            .init(id: "V-014B", name: "Graphite/Carbon", color: "Gray", size: nil, additionalPrice: 0, isInStock: true),
            .init(id: "V-014C", name: "Dusty Rose", color: "Pink", size: nil, additionalPrice: 0, isInStock: true)
        ],
        tags: ["luxury", "top-rated", "bestseller"],
        isInStock: true,
        stockCount: 156,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(1 * 86400), latest: Date().addingTimeInterval(3 * 86400)),
        isFeatured: true,
        isNew: false,
        createdAt: Date().addingTimeInterval(-200 * 86400)
    )

    static let mockSheetSet = Product(
        id: "PRD-025",
        name: "CGK Unlimited Luxury Hotel Sheet Set",
        brand: "CGK Unlimited",
        description: "Brushed microfiber sheets with deep pockets. Wrinkle-free, fade-resistant, and hypoallergenic. Includes flat sheet, fitted sheet, and 2 pillowcases.",
        price: 39.99,
        salePrice: 29.99,
        currency: AppConstants.Currency.code,
        images: [.init(url: "https://picsum.photos/seed/sheetset/600/600", alt: "Sheet set")],
        category: .init(path: ["Bedding", "Sheet Sets"]),
        rating: 4.5,
        reviewCount: 12340,
        specs: [
            .init(label: "Thread Count", value: "1800"),
            .init(label: "Material", value: "Brushed Microfiber"),
            .init(label: "Deep Pockets", value: "Up to 16 inches")
        ],
        variants: [
            .init(id: "V-025A", name: "Queen - White", color: "White", size: "Queen", additionalPrice: 0, isInStock: true),
            .init(id: "V-025B", name: "Queen - Gray", color: "Gray", size: "Queen", additionalPrice: 0, isInStock: true),
            .init(id: "V-025C", name: "King - White", color: "White", size: "King", additionalPrice: 10, isInStock: true)
        ],
        tags: ["bestseller", "value-pack"],
        isInStock: true,
        stockCount: 890,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(1 * 86400), latest: Date().addingTimeInterval(2 * 86400)),
        isFeatured: false,
        isNew: false,
        createdAt: Date().addingTimeInterval(-150 * 86400)
    )

    // MARK: - Rugs

    static let mockAreaRug = Product(
        id: "PRD-005",
        name: "nuLOOM Moroccan Blythe Area Rug",
        brand: "nuLOOM",
        description: "Add texture and warmth to any room with this popular Moroccan-inspired area rug. Machine-made for durability with a soft polypropylene pile.",
        price: 179.99,
        salePrice: 129.99,
        currency: AppConstants.Currency.code,
        images: [.init(url: "https://picsum.photos/seed/arearug/600/600", alt: "Moroccan area rug")],
        category: .init(path: ["Rugs", "Area Rugs"]),
        rating: 4.4,
        reviewCount: 5678,
        specs: [
            .init(label: "Size", value: "8' x 10'"),
            .init(label: "Material", value: "Polypropylene"),
            .init(label: "Pile Height", value: "0.37 inches")
        ],
        variants: [],
        tags: ["top-rated", "free-shipping"],
        isInStock: true,
        stockCount: 200,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(2 * 86400), latest: Date().addingTimeInterval(5 * 86400)),
        isFeatured: true,
        isNew: false,
        createdAt: Date().addingTimeInterval(-20 * 86400)
    )

    static let mockRunnerRug = Product(
        id: "PRD-026",
        name: "ReaLife Washable Runner Rug 2x7",
        brand: "ReaLife",
        description: "Stain-resistant, machine-washable runner rug for hallways, kitchens, and entryways. Made from 100% recycled cotton.",
        price: 49.99,
        salePrice: nil,
        currency: AppConstants.Currency.code,
        images: [.init(url: "https://picsum.photos/seed/runnerrug/600/600", alt: "Runner rug")],
        category: .init(path: ["Rugs", "Runner Rugs"]),
        rating: 4.3,
        reviewCount: 2345,
        specs: [
            .init(label: "Size", value: "2' x 7'"),
            .init(label: "Material", value: "100% Recycled Cotton"),
            .init(label: "Care", value: "Machine Washable")
        ],
        variants: [],
        tags: ["eco-friendly"],
        isInStock: true,
        stockCount: 190,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(2 * 86400), latest: Date().addingTimeInterval(4 * 86400)),
        isFeatured: false,
        isNew: true,
        createdAt: Date().addingTimeInterval(-9 * 86400)
    )

    // MARK: - Kitchen

    static let mockKitchenFaucet = Product(
        id: "PRD-013",
        name: "Delta Trinsic Pull-Down Kitchen Faucet",
        brand: "Delta",
        description: "Professional-grade kitchen faucet with Touch2O Technology. Simply touch anywhere on the faucet to start and stop water flow.",
        price: 379.99,
        salePrice: 329.99,
        currency: AppConstants.Currency.code,
        images: [.init(url: "https://picsum.photos/seed/faucet/600/600", alt: "Kitchen faucet")],
        category: .init(path: ["Kitchen", "Faucets"]),
        rating: 4.6,
        reviewCount: 1567,
        specs: [
            .init(label: "Finish", value: "Arctic Stainless"),
            .init(label: "Technology", value: "Touch2O"),
            .init(label: "Hose Length", value: "59 inches")
        ],
        variants: [],
        tags: ["smart-home"],
        isInStock: true,
        stockCount: 28,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(2 * 86400), latest: Date().addingTimeInterval(5 * 86400)),
        isFeatured: true,
        isNew: false,
        createdAt: Date().addingTimeInterval(-55 * 86400)
    )

    static let mockKnifeSet = Product(
        id: "PRD-027",
        name: "Henckels Modernist 14-Piece Knife Block Set",
        brand: "Henckels",
        description: "Professional-quality German stainless steel knives. Self-sharpening block maintains blade edge. Includes chef, bread, utility, paring, steak knives and more.",
        price: 199.99,
        salePrice: 149.99,
        currency: AppConstants.Currency.code,
        images: [.init(url: "https://picsum.photos/seed/knifeset/600/600", alt: "Knife block set")],
        category: .init(path: ["Kitchen", "Cutlery"]),
        rating: 4.7,
        reviewCount: 3678,
        specs: [
            .init(label: "Pieces", value: "14"),
            .init(label: "Material", value: "German Stainless Steel"),
            .init(label: "Block", value: "Self-Sharpening")
        ],
        variants: [],
        tags: ["bestseller", "free-shipping"],
        isInStock: true,
        stockCount: 56,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(1 * 86400), latest: Date().addingTimeInterval(3 * 86400)),
        isFeatured: false,
        isNew: false,
        createdAt: Date().addingTimeInterval(-80 * 86400)
    )

    static let mockMixerStand = Product(
        id: "PRD-028",
        name: "KitchenAid Artisan Stand Mixer 5-Qt",
        brand: "KitchenAid",
        description: "Iconic tilt-head stand mixer with 10 speeds. Includes flat beater, dough hook, and wire whip. 15+ optional attachments available.",
        price: 449.99,
        salePrice: nil,
        currency: AppConstants.Currency.code,
        images: [.init(url: "https://picsum.photos/seed/standmixer/600/600", alt: "Stand mixer")],
        category: .init(path: ["Kitchen", "Appliances"]),
        rating: 4.8,
        reviewCount: 15230,
        specs: [
            .init(label: "Capacity", value: "5 quart"),
            .init(label: "Motor", value: "325 watt"),
            .init(label: "Speeds", value: "10")
        ],
        variants: [
            .init(id: "V-028A", name: "Empire Red", color: "Red", size: nil, additionalPrice: 0, isInStock: true),
            .init(id: "V-028B", name: "Onyx Black", color: "Black", size: nil, additionalPrice: 0, isInStock: true),
            .init(id: "V-028C", name: "Pistachio", color: "Green", size: nil, additionalPrice: 20, isInStock: true)
        ],
        tags: ["luxury", "top-rated"],
        isInStock: true,
        stockCount: 42,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(2 * 86400), latest: Date().addingTimeInterval(5 * 86400)),
        isFeatured: true,
        isNew: false,
        createdAt: Date().addingTimeInterval(-100 * 86400)
    )

    // MARK: - Smart Home

    static let mockSmartPlug = Product(
        id: "PRD-015",
        name: "Kasa Smart Plug (4-Pack)",
        brand: "TP-Link",
        description: "Control your home appliances from anywhere with these WiFi smart plugs. Works with Alexa, Google Home, and Apple HomeKit.",
        price: 29.99,
        salePrice: 22.99,
        currency: AppConstants.Currency.code,
        images: [.init(url: "https://picsum.photos/seed/smartplug/600/600", alt: "Smart plug set")],
        category: .init(path: ["Smart Home", "Plugs & Outlets"]),
        rating: 4.7,
        reviewCount: 12456,
        specs: [
            .init(label: "Quantity", value: "4 pack"),
            .init(label: "Connectivity", value: "WiFi 2.4GHz"),
            .init(label: "Compatibility", value: "Alexa, Google, HomeKit")
        ],
        variants: [],
        tags: ["smart-home", "bestseller", "value-pack"],
        isInStock: true,
        stockCount: 890,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(1 * 86400), latest: Date().addingTimeInterval(2 * 86400)),
        isFeatured: false,
        isNew: true,
        createdAt: Date().addingTimeInterval(-7 * 86400)
    )

    static let mockSmartThermostat = Product(
        id: "PRD-029",
        name: "ecobee Smart Thermostat Premium",
        brand: "ecobee",
        description: "Save up to 26% on energy costs with smart sensors, built-in Alexa, and air quality monitoring. Works with Apple HomeKit.",
        price: 249.99,
        salePrice: 219.99,
        currency: AppConstants.Currency.code,
        images: [.init(url: "https://picsum.photos/seed/thermostat/600/600", alt: "Smart thermostat")],
        category: .init(path: ["Smart Home", "Thermostats"]),
        rating: 4.5,
        reviewCount: 4567,
        specs: [
            .init(label: "Display", value: "3.5\" Touchscreen"),
            .init(label: "Sensors", value: "SmartSensor included"),
            .init(label: "Compatibility", value: "HomeKit, Alexa built-in")
        ],
        variants: [],
        tags: ["smart-home", "energy-efficient"],
        isInStock: true,
        stockCount: 63,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(1 * 86400), latest: Date().addingTimeInterval(3 * 86400)),
        isFeatured: false,
        isNew: false,
        createdAt: Date().addingTimeInterval(-45 * 86400)
    )

    // MARK: - Storage

    static let mockStorageBins = Product(
        id: "PRD-030",
        name: "mDesign Stackable Closet Storage Bins (Set of 6)",
        brand: "mDesign",
        description: "Fabric storage bins with clear windows and reinforced handles. Stack and organize closets, shelves, and cabinets.",
        price: 44.99,
        salePrice: 34.99,
        currency: AppConstants.Currency.code,
        images: [.init(url: "https://picsum.photos/seed/storagebins/600/600", alt: "Storage bins")],
        category: .init(path: ["Storage", "Closet Organization"]),
        rating: 4.4,
        reviewCount: 5890,
        specs: [
            .init(label: "Size", value: "11\" x 11\" x 11\" each"),
            .init(label: "Material", value: "Polyester Fabric"),
            .init(label: "Quantity", value: "Set of 6")
        ],
        variants: [
            .init(id: "V-030A", name: "Charcoal Gray", color: "Gray", size: nil, additionalPrice: 0, isInStock: true),
            .init(id: "V-030B", name: "Linen", color: "Beige", size: nil, additionalPrice: 0, isInStock: true)
        ],
        tags: ["value-pack"],
        isInStock: true,
        stockCount: 412,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(1 * 86400), latest: Date().addingTimeInterval(3 * 86400)),
        isFeatured: false,
        isNew: false,
        createdAt: Date().addingTimeInterval(-60 * 86400)
    )

    // MARK: - All Products

    static let mockProducts: [Product] = [
        .mockSofa, .mockDiningTable, .mockFloorLamp, .mockBedFrame, .mockAreaRug,
        .mockBarStools, .mockShowerHead, .mockCurtains, .mockVanity, .mockWallArt,
        .mockDeskChair, .mockPlanters, .mockKitchenFaucet, .mockThrowBlanket, .mockSmartPlug,
        .mockBookshelf, .mockSideTable, .mockPendantLight, .mockTableLamp, .mockBathTowels,
        .mockMirror, .mockThrowPillows, .mockPatioSet, .mockStringLights, .mockSheetSet,
        .mockRunnerRug, .mockKnifeSet, .mockMixerStand, .mockSmartThermostat, .mockStorageBins
    ]

    // MARK: - Products by Category

    static let furnitureProducts: [Product] = [.mockSofa, .mockDiningTable, .mockBedFrame, .mockBarStools, .mockDeskChair, .mockBookshelf, .mockSideTable]
    static let lightingProducts: [Product] = [.mockFloorLamp, .mockPendantLight, .mockTableLamp]
    static let bathProducts: [Product] = [.mockShowerHead, .mockVanity, .mockBathTowels]
    static let decorProducts: [Product] = [.mockCurtains, .mockWallArt, .mockMirror, .mockThrowPillows]
    static let outdoorProducts: [Product] = [.mockPlanters, .mockPatioSet, .mockStringLights]
    static let beddingProducts: [Product] = [.mockThrowBlanket, .mockSheetSet]
    static let rugProducts: [Product] = [.mockAreaRug, .mockRunnerRug]
    static let kitchenProducts: [Product] = [.mockKitchenFaucet, .mockKnifeSet, .mockMixerStand]
    static let smartHomeProducts: [Product] = [.mockSmartPlug, .mockSmartThermostat]
    static let storageProducts: [Product] = [.mockStorageBins]
}
