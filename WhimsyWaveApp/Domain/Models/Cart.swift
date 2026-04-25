import Foundation

struct Cart: Equatable, Sendable {
    var items: [CartItem]

    var totalPrice: Decimal {
        items.reduce(Decimal.zero) { $0 + $1.lineTotal }
    }

    var itemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    var isEmpty: Bool {
        items.isEmpty
    }

    var displayTotal: String {
        let currencyCode = items.first?.product.currency ?? "USD"
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        return formatter.string(from: totalPrice as NSDecimalNumber) ?? "$0.00"
    }

    static let empty = Cart(items: [])
}
