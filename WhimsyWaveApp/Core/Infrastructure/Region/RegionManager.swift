import Foundation
import Observation

@Observable @MainActor
final class RegionManager {
    static let shared = RegionManager()

    var currentRegion: Region {
        didSet {
            PreferencesStore.set(currentRegion.rawValue, for: .selectedRegion)
        }
    }

    private init() {
        if let saved = PreferencesStore.string(for: .selectedRegion),
           let region = Region(rawValue: saved) {
            currentRegion = region
        } else {
            currentRegion = .us
        }
    }
}
