import Foundation

enum PriceFormatter {
    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = AppConstants.Currency.code
        return formatter
    }()

    static func format(_ value: Decimal) -> String {
        formatter.string(from: value as NSDecimalNumber) ?? "$0.00"
    }

    static func formatOrFree(_ value: Decimal) -> String {
        value == 0 ? "FREE" : format(value)
    }
}
