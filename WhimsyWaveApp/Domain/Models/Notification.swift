import Foundation

struct AppNotification: Identifiable, Equatable, Sendable, Codable {
    let id: String
    let title: String
    let body: String
    let type: AppNotificationType
    var isRead: Bool
    let deepLink: String?
    let imageURL: String?
    let createdAt: Date

    init(
        id: String = UUID().uuidString,
        title: String,
        body: String,
        type: AppNotificationType,
        isRead: Bool = false,
        deepLink: String? = nil,
        imageURL: String? = nil,
        createdAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.body = body
        self.type = type
        self.isRead = isRead
        self.deepLink = deepLink
        self.imageURL = imageURL
        self.createdAt = createdAt
    }
}

enum AppNotificationType: String, Codable, Equatable, Sendable {
    case orderUpdate
    case promotion
    case priceAlert
    case deliveryUpdate
    case general
}
