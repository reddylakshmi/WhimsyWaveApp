import SwiftUI

struct SettingsView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("biometricAuth") private var biometricAuth = false

    var body: some View {
        Form {
            Section("Notifications") {
                Toggle("Push Notifications", isOn: $notificationsEnabled)
            }

            Section("Security") {
                Toggle("Face ID / Touch ID", isOn: $biometricAuth)
            }

            Section("About") {
                HStack {
                    Text("Version")
                    Spacer()
                    Text(AppConfiguration.current.minimumAppVersion)
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text("Environment")
                    Spacer()
                    Text(AppConfiguration.current.environment.rawValue.capitalized)
                        .foregroundStyle(.secondary)
                }
            }

            Section {
                Link("Contact Support", destination: URL(string: "mailto:\(AppConfiguration.current.supportEmail)")!)
                Link("Rate the App", destination: AppConfiguration.current.appStoreURL)
            }
        }
        .navigationTitle("Settings")
    }
}
