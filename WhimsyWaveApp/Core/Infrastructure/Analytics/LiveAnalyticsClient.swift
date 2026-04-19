import Foundation

enum LiveAnalyticsClient {
    static func makeClient() -> AnalyticsClient {
        AnalyticsClient(
            track: { event in
                AppLogger.debug("Track: \(event)", category: .analytics)
            },
            screen: { screen in
                AppLogger.debug("Screen: \(screen.rawValue)", category: .analytics)
            },
            identify: { properties in
                AppLogger.debug("Identify: \(properties.userId)", category: .analytics)
            }
        )
    }
}
