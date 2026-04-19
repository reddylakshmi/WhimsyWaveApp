import Foundation
import UserNotifications

struct PushNotificationClient: Sendable {
    var requestAuthorization: @Sendable () async throws -> Bool
    var getDeepLink: @Sendable ([AnyHashable: Any]) -> DeepLink?
}

extension PushNotificationClient {
    static let live = PushNotificationClient(
        requestAuthorization: {
            let center = UNUserNotificationCenter.current()
            return try await center.requestAuthorization(options: [.alert, .badge, .sound])
        },
        getDeepLink: { userInfo in
            DeepLinkHandler.parse(notificationUserInfo: userInfo)
        }
    )

    static let noop = PushNotificationClient(
        requestAuthorization: { false },
        getDeepLink: { _ in nil }
    )
}
