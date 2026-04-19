import Foundation
import OSLog

enum LocalFeatureFlagClient {
    private static var flagStore: [String: Any] = loadDefaults()

    static func makeClient() -> FeatureFlagClient {
        FeatureFlagClient(
            boolValue: { flag in
                flagStore[flag.rawValue] as? Bool ?? false
            },
            stringValue: { flag in
                flagStore[flag.rawValue] as? String
            },
            intValue: { flag in
                flagStore[flag.rawValue] as? Int
            }
        )
    }

    private static func loadDefaults() -> [String: Any] {
        guard let url = Bundle.main.url(forResource: "flags-default", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            AppLogger.log("Failed to load feature flags defaults", level: .error, category: .featureFlags)
            return [:]
        }
        return json
    }
}
