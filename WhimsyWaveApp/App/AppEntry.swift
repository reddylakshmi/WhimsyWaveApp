import SwiftUI

@main
struct WhimsyWaveApp: App {
    @State private var appReducer = AppReducer()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            AppView(app: appReducer)
                // Drives the SwiftUI locale environment from the selected region.
                // When the user changes region (e.g., to Canada French), this ensures
                // all String Catalog lookups and native formatters switch language.
                .environment(\.locale, RegionManager.shared.currentRegion.locale)
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
                    // Run storage cleanup
                    StorageCleanupWorker.performCleanupIfNeeded()
                }
                .onOpenURL { url in
                    if let deepLink = DeepLinkHandler.parse(url: url) {
                        appReducer.handleDeepLink(deepLink)
                    }
                }
        }
    }
}
