import Foundation

enum PreferencesStore {
    enum Key: String {
        case hasCompletedOnboarding
        case preferredCurrency
        case recentSearches
        case lastSyncTimestamp
        case selectedTheme
        case notificationsEnabled
        case biometricAuthEnabled
        case selectedRegion
    }

    private static let defaults = UserDefaults.standard

    static func set(_ value: Any, for key: Key) {
        defaults.set(value, forKey: key.rawValue)
    }

    static func string(for key: Key) -> String? {
        defaults.string(forKey: key.rawValue)
    }

    static func bool(for key: Key) -> Bool {
        defaults.bool(forKey: key.rawValue)
    }

    static func integer(for key: Key) -> Int {
        defaults.integer(forKey: key.rawValue)
    }

    static func stringArray(for key: Key) -> [String] {
        defaults.stringArray(forKey: key.rawValue) ?? []
    }

    static func setStringArray(_ value: [String], for key: Key) {
        defaults.set(value, forKey: key.rawValue)
    }

    static func date(for key: Key) -> Date? {
        defaults.object(forKey: key.rawValue) as? Date
    }

    static func remove(for key: Key) {
        defaults.removeObject(forKey: key.rawValue)
    }
}
