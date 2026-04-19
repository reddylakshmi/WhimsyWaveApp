import Foundation

struct Banner: Identifiable, Equatable, Sendable, Codable {
    let id: String
    let title: String
    let subtitle: String
    let imageURL: String
    let backgroundColor: String?
    let deepLink: String?
    let expiresAt: Date?

    init(
        id: String = UUID().uuidString,
        title: String,
        subtitle: String,
        imageURL: String,
        backgroundColor: String? = nil,
        deepLink: String? = nil,
        expiresAt: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.backgroundColor = backgroundColor
        self.deepLink = deepLink
        self.expiresAt = expiresAt
    }
}
