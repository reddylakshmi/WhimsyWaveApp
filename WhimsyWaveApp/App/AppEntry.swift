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
                .onOpenURL { url in
                    if let deepLink = DeepLinkHandler.parse(url: url) {
                        appReducer.handleDeepLink(deepLink)
                    }
                }
        }
    }
}
