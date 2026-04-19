import SwiftUI

@main
struct WhimsyWaveApp: App {
    @State private var appReducer = AppReducer()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            AppView(app: appReducer)
                .onOpenURL { url in
                    if let deepLink = DeepLinkHandler.parse(url: url) {
                        appReducer.handleDeepLink(deepLink)
                    }
                }
        }
    }
}
