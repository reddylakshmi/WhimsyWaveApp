import SwiftUI

struct SettingsView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("biometricAuth") private var biometricAuth = false

    var body: some View {
        Form {
            Section("settings.notifications") {
                Toggle("settings.pushNotifications", isOn: $notificationsEnabled)
            }

            Section("settings.security") {
                Toggle("settings.biometric", isOn: $biometricAuth)
            }

            Section("settings.about") {
                HStack {
                    Text("settings.version")
                    Spacer()
                    Text(AppConfiguration.current.minimumAppVersion)
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text("settings.environment")
                    Spacer()
                    Text(AppConfiguration.current.environment.rawValue.capitalized)
                        .foregroundStyle(.secondary)
                }
            }

            Section {
                Link(destination: URL(string: "mailto:\(AppConfiguration.current.supportEmail)")!) {
                    Text("settings.contactSupport")
                }
                Link(destination: AppConfiguration.current.appStoreURL) {
                    Text("settings.rateApp")
                }
            }
        }
        .navigationTitle("settings.title")
    }
}
