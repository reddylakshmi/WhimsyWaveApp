import SwiftUI

@main
struct WhimsyWaveApp: App {
    @State private var appReducer = AppReducer()
    @State private var isDataReady = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            Group {
                if isDataReady {
                    AppView(app: appReducer)
                        .environment(\.locale, RegionManager.shared.currentRegion.locale)
                        .onOpenURL { url in
                            if let deepLink = DeepLinkHandler.parse(url: url) {
                                appReducer.handleDeepLink(deepLink)
                            }
                        }
                } else {
                    ProgressView()
                }
            }
            .task {
                // Initialize SQLite database and perform initial data ingestion
                let container = ServiceContainer.current
                do {
                    try await container.sqliteStore.initialize()
                    await container.ingestionWorker.performInitialIngestionIfNeeded(
                        for: RegionManager.shared.currentRegion
                    )
                } catch {
                    print("Failed to initialize data layer: \(error)")
                }
                isDataReady = true
                StorageCleanupWorker.performCleanupIfNeeded()
            }
        }
    }
}
