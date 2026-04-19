import Foundation

extension Cart {
    static let mockCart = Cart(items: [
        CartItem(id: "CI-001", product: .mockSofa, quantity: 1),
        CartItem(id: "CI-002", product: .mockFloorLamp, quantity: 2),
        CartItem(id: "CI-003", product: .mockAreaRug, quantity: 1)
    ])

    static let mockSingleItem = Cart(items: [
        CartItem(id: "CI-004", product: .mockThrowBlanket, quantity: 1)
    ])
}
