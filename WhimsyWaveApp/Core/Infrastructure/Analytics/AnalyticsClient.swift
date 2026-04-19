import Foundation

struct AnalyticsClient: Sendable {
    var track: @Sendable (AnalyticsEvent) -> Void
    var screen: @Sendable (ScreenName) -> Void
    var identify: @Sendable (UserProperties) -> Void
}

extension AnalyticsClient {
    static let live = LiveAnalyticsClient.makeClient()

    static let noop = AnalyticsClient(
        track: { _ in },
        screen: { _ in },
        identify: { _ in }
    )

    static let mock = MockAnalyticsClient.makeClient()
}
