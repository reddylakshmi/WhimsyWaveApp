import SwiftUI

struct ProfileView: View {
    @Bindable var feature: ProfileFeature
    var onOrdersTapped: () -> Void = {}

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: AppSpacing.md) {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: AppConstants.Image.avatarSize, height: AppConstants.Image.avatarSize)
                            .overlay {
                                Text(feature.user?.initials ?? "GU")
                                    .font(.title2.bold())
                                    .foregroundStyle(.secondary)
                            }

                        VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                            Text(feature.user?.fullName ?? "Guest User")
                                .font(.headline)
                            Text(feature.user?.email ?? "")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            if let tier = feature.user?.membershipTier, tier != .standard {
                                Text(tier.displayName)
                                    .font(.caption.bold())
                                    .padding(.horizontal, AppSpacing.sm)
                                    .padding(.vertical, AppSpacing.xxs)
                                    .background(Capsule().fill(.orange.opacity(0.1)))
                                    .foregroundStyle(.orange)
                            }
                        }
                    }
                    .padding(.vertical, AppSpacing.sm)
                }

                Section("Shopping") {
                    Button(action: onOrdersTapped) {
                        Label("Order History", systemImage: "bag")
                    }
                    NavigationLink {
                        AddressListView(feature: feature)
                    } label: {
                        Label("Addresses", systemImage: "mappin.and.ellipse")
                    }
                    NavigationLink {
                        PaymentMethodsView(feature: feature)
                    } label: {
                        Label("Payment Methods", systemImage: "creditcard")
                    }
                }

                Section("Preferences") {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Label("Settings", systemImage: "gearshape")
                    }
                    NavigationLink {
                        Text("Help & Support")
                    } label: {
                        Label("Help & Support", systemImage: "questionmark.circle")
                    }
                }

                Section {
                    Button(role: .destructive) {
                        feature.logout()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Log Out").fontWeight(.bold)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Profile")
            .task { await feature.loadProfile() }
        }
    }
}
