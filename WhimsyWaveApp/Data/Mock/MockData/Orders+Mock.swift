import Foundation

extension Order {
    static let mockDelivered = Order(
        id: "ORD-001",
        orderNumber: "WW-2026-78432",
        items: [
            OrderItem(id: "OI-001", productId: "PRD-001", name: "Serta Upholstered Convertible Sofa", brand: "Serta", price: 649.99, quantity: 1, image: "https://picsum.photos/seed/sofa/600/600", selectedVariant: "Charcoal Gray"),
            OrderItem(id: "OI-002", productId: "PRD-003", name: "Brightech Sky LED Floor Lamp", brand: "Brightech", price: 54.99, quantity: 2, image: "https://picsum.photos/seed/floorlamp/600/600", selectedVariant: nil)
        ],
        subtotal: 759.97,
        shippingCost: 0,
        tax: 62.70,
        totalAmount: 822.67,
        status: .delivered,
        createdAt: Date().addingTimeInterval(-14 * 86400),
        updatedAt: Date().addingTimeInterval(-2 * 86400),
        shippingAddress: .mockHome,
        paymentMethod: PaymentSummary(type: "Visa", lastFourDigits: "4242"),
        trackingNumber: "1Z999AA10123456784",
        estimatedDelivery: nil
    )

    static let mockShipped = Order(
        id: "ORD-002",
        orderNumber: "WW-2026-78591",
        items: [
            OrderItem(id: "OI-003", productId: "PRD-005", name: "nuLOOM Moroccan Blythe Area Rug", brand: "nuLOOM", price: 129.99, quantity: 1, image: "https://picsum.photos/seed/arearug/600/600", selectedVariant: nil)
        ],
        subtotal: 129.99,
        shippingCost: 9.99,
        tax: 11.55,
        totalAmount: 151.53,
        status: .shipped,
        createdAt: Date().addingTimeInterval(-3 * 86400),
        updatedAt: Date().addingTimeInterval(-1 * 86400),
        shippingAddress: .mockOffice,
        paymentMethod: PaymentSummary(type: "Mastercard", lastFourDigits: "8831"),
        trackingNumber: "9400111899223100456789",
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(2 * 86400), latest: Date().addingTimeInterval(4 * 86400))
    )

    static let mockPlaced = Order(
        id: "ORD-003",
        orderNumber: "WW-2026-78610",
        items: [
            OrderItem(id: "OI-004", productId: "PRD-013", name: "Delta Trinsic Pull-Down Kitchen Faucet", brand: "Delta", price: 329.99, quantity: 1, image: "https://picsum.photos/seed/faucet/600/600", selectedVariant: nil),
            OrderItem(id: "OI-005", productId: "PRD-015", name: "Kasa Smart Plug (4-Pack)", brand: "TP-Link", price: 22.99, quantity: 1, image: "https://picsum.photos/seed/smartplug/600/600", selectedVariant: nil)
        ],
        subtotal: 352.98,
        shippingCost: 0,
        tax: 29.12,
        totalAmount: 382.10,
        status: .placed,
        createdAt: Date().addingTimeInterval(-0.5 * 86400),
        updatedAt: Date().addingTimeInterval(-0.5 * 86400),
        shippingAddress: .mockHome,
        paymentMethod: PaymentSummary(type: "Apple Pay", lastFourDigits: ""),
        trackingNumber: nil,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(5 * 86400), latest: Date().addingTimeInterval(9 * 86400))
    )

    static let mockProcessing = Order(
        id: "ORD-004",
        orderNumber: "WW-2026-78655",
        items: [
            OrderItem(id: "OI-006", productId: "PRD-028", name: "KitchenAid Artisan Stand Mixer 5-Qt", brand: "KitchenAid", price: 449.99, quantity: 1, image: "https://picsum.photos/seed/standmixer/600/600", selectedVariant: "Empire Red"),
            OrderItem(id: "OI-007", productId: "PRD-027", name: "Henckels Modernist 14-Piece Knife Block Set", brand: "Henckels", price: 149.99, quantity: 1, image: "https://picsum.photos/seed/knifeset/600/600", selectedVariant: nil)
        ],
        subtotal: 599.98,
        shippingCost: 0,
        tax: 49.50,
        totalAmount: 649.48,
        status: .processing,
        createdAt: Date().addingTimeInterval(-1 * 86400),
        updatedAt: Date().addingTimeInterval(-0.5 * 86400),
        shippingAddress: .mockHome,
        paymentMethod: PaymentSummary(type: "Visa", lastFourDigits: "4242"),
        trackingNumber: nil,
        estimatedDelivery: .init(earliest: Date().addingTimeInterval(4 * 86400), latest: Date().addingTimeInterval(7 * 86400))
    )

    static let mockCancelled = Order(
        id: "ORD-005",
        orderNumber: "WW-2026-78320",
        items: [
            OrderItem(id: "OI-008", productId: "PRD-023", name: "UDPATIO 4-Piece Outdoor Conversation Set", brand: "UDPATIO", price: 349.99, quantity: 1, image: "https://picsum.photos/seed/patioset/600/600", selectedVariant: "Dark Brown / Beige")
        ],
        subtotal: 349.99,
        shippingCost: 0,
        tax: 28.87,
        totalAmount: 378.86,
        status: .cancelled,
        createdAt: Date().addingTimeInterval(-21 * 86400),
        updatedAt: Date().addingTimeInterval(-19 * 86400),
        shippingAddress: .mockHome,
        paymentMethod: PaymentSummary(type: "Mastercard", lastFourDigits: "8831"),
        trackingNumber: nil,
        estimatedDelivery: nil
    )

    static let mockOrders: [Order] = [.mockPlaced, .mockProcessing, .mockShipped, .mockDelivered, .mockCancelled]
}
