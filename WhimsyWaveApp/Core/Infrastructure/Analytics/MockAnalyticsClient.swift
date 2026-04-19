import Foundation

enum MockAnalyticsClient {
    static func makeClient() -> AnalyticsClient {
        AnalyticsClient(
            track: { _ in },
            screen: { _ in },
            identify: { _ in }
        )
    }
}
