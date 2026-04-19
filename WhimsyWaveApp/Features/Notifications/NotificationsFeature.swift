import Foundation
import Observation

@Observable @MainActor
final class NotificationsFeature {
    var notifications: [AppNotification] = []
    var isLoading = false

    var unreadCount: Int {
        notifications.filter { !$0.isRead }.count
    }

    func loadNotifications() async {
        isLoading = true
        notifications = [
            AppNotification(title: "Order Shipped", body: "Your order #WW-2026-78591 has been shipped and is on its way!", type: .orderUpdate, deepLink: "whimsywave://order/ORD-002", createdAt: Date().addingTimeInterval(-1 * 86400)),
            AppNotification(title: "Price Drop Alert", body: "Serta Convertible Sofa is now 28% off! Don't miss out.", type: .priceAlert, deepLink: "whimsywave://product/PRD-001", createdAt: Date().addingTimeInterval(-2 * 86400)),
            AppNotification(title: "Spring Sale is Live", body: "Up to 40% off furniture & decor. Shop now!", type: .promotion, isRead: true, deepLink: "whimsywave://promotion/spring-sale", createdAt: Date().addingTimeInterval(-3 * 86400)),
            AppNotification(title: "Welcome to Whimsy Wave", body: "Start exploring thousands of products for your home.", type: .general, isRead: true, createdAt: Date().addingTimeInterval(-7 * 86400))
        ]
        isLoading = false
    }

    func markAsRead(_ notification: AppNotification) {
        if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
            notifications[index].isRead = true
        }
    }

    func markAllAsRead() {
        for i in notifications.indices {
            notifications[i].isRead = true
        }
    }
}
