import Foundation

struct FeatureFlagClient: Sendable {
    var boolValue: @Sendable (FeatureFlag) -> Bool
    var stringValue: @Sendable (FeatureFlag) -> String?
    var intValue: @Sendable (FeatureFlag) -> Int?

    func isEnabled(_ flag: FeatureFlag) -> Bool {
        boolValue(flag)
    }
}

extension FeatureFlagClient {
    static let live = LocalFeatureFlagClient.makeClient()

    static let allEnabled = FeatureFlagClient(
        boolValue: { _ in true },
        stringValue: { _ in nil },
        intValue: { _ in nil }
    )

    static let allDisabled = FeatureFlagClient(
        boolValue: { _ in false },
        stringValue: { _ in nil },
        intValue: { _ in nil }
    )
}
