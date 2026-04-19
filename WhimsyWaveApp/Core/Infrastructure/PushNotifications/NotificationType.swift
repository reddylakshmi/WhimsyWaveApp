import Foundation

enum NotificationType: String, Sendable {
    case orderUpdate = "order_update"
    case priceDrop = "price_drop"
    case promotion = "promotion"
    case cartReminder = "cart_reminder"
    case backInStock = "back_in_stock"
    case deliveryUpdate = "delivery_update"
    case reviewReminder = "review_reminder"
}
