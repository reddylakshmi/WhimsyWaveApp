import Foundation
import Observation

@Observable @MainActor
final class ARFeature {
    var isEnabled: Bool
    var product: Product?
    var isLoading = false

    init(featureFlags: FeatureFlagClient = MockServiceProvider.featureFlagClient) {
        isEnabled = featureFlags.isEnabled(.arViewEnabled)
    }
}
