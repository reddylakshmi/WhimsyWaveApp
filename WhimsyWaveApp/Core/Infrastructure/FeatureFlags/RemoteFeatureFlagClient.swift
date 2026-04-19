import Foundation

enum RemoteFeatureFlagClient {

    static func makeClient() -> FeatureFlagClient {
        let store = FlagStore()
        return FeatureFlagClient(
            boolValue: { flag in
                store.value(for: flag) as? Bool ?? false
            },
            stringValue: { flag in
                store.value(for: flag) as? String
            },
            intValue: { flag in
                store.value(for: flag) as? Int
            }
        )
    }
}

private final class FlagStore: @unchecked Sendable {
    private var flags: [String: Any] = [:]
    private let lock = NSLock()

    func value(for flag: FeatureFlag) -> Any? {
        lock.lock()
        defer { lock.unlock() }
        return flags[flag.rawValue]
    }

    func update(with remote: [String: Any]) {
        lock.lock()
        defer { lock.unlock() }
        flags.merge(remote) { _, new in new }
    }
}
