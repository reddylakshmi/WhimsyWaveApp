import Foundation
import SwiftData

enum SwiftDataStore {
    static func makeContainer() -> ModelContainer {
        let schema = Schema([])
        let config = ModelConfiguration(isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            AppLogger.fault("SwiftData container creation failed: \(error)", category: .persistence)
            fatalError("SwiftData container creation failed: \(error)")
        }
    }

    static func makePreviewContainer() -> ModelContainer {
        let schema = Schema([])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Preview container creation failed: \(error)")
        }
    }
}
