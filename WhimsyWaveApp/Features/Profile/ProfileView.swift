import SwiftUI

struct AccountView: View {
    @Bindable var feature: AccountFeature
    var onOrdersTapped: () -> Void = {}
    var onRegionChanged: (() -> Void)?

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
                            Text(feature.user?.fullName ?? String(localized: "guest.user", defaultValue: "Guest User", locale: RegionManager.shared.currentRegion.locale))
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

                RegionPickerSection(onRegionChanged: onRegionChanged)

                Section("account.shopping") {
                    Button(action: onOrdersTapped) {
                        Label("account.orderHistory", systemImage: "bag")
                    }
                    NavigationLink {
                        AddressListView(feature: feature)
                    } label: {
                        Label("account.addresses", systemImage: "mappin.and.ellipse")
                    }
                    NavigationLink {
                        PaymentMethodsView(feature: feature)
                    } label: {
                        Label("account.paymentMethods", systemImage: "creditcard")
                    }
                }

                Section("account.preferences") {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Label("account.settings", systemImage: "gearshape")
                    }
                    NavigationLink {
                        Text("account.helpSupport")
                    } label: {
                        Label("account.helpSupport", systemImage: "questionmark.circle")
                    }
                }

                Section {
                    Button(role: .destructive) {
                        feature.logout()
                    } label: {
                        HStack {
                            Spacer()
                            Text("action.logOut").fontWeight(.bold)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle(Text("tab.account"))
            .task { await feature.loadProfile() }
        }
    }
}

// MARK: - Region Picker Section

struct RegionPickerSection: View {
    var onRegionChanged: (() -> Void)?
    @State private var showingRegionPicker = false

    private var regionManager: RegionManager { RegionManager.shared }

    var body: some View {
        Section("region.title") {
            Button {
                showingRegionPicker = true
            } label: {
                HStack {
                    Label {
                        Text(regionManager.currentRegion.displayName)
                            .foregroundStyle(.primary)
                    } icon: {
                        Text(regionManager.currentRegion.flag)
                            .font(.title2)
                    }
                    Spacer()
                    Text(regionManager.currentRegion.currencyCode)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            .accessibilityLabel("\(regionManager.currentRegion.displayName), \(regionManager.currentRegion.currencyCode)")
            .accessibilityHint(Text("accessibility.changeRegion"))
        }
        .sheet(isPresented: $showingRegionPicker) {
            RegionPickerView(onRegionChanged: onRegionChanged)
        }
    }
}

// MARK: - Region Picker View

struct RegionPickerView: View {
    var onRegionChanged: (() -> Void)?
    @Environment(\.dismiss) private var dismiss

    private var regionManager: RegionManager { RegionManager.shared }

    var body: some View {
        NavigationStack {
            List {
                ForEach(Region.allCases) { region in
                    regionRow(region)
                }
            }
            .navigationTitle(Text("region.select"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { dismiss() } label: {
                        Text("nav.cancel")
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private func regionRow(_ region: Region) -> some View {
        let isSelected = regionManager.currentRegion == region
        return Button {
            if !isSelected {
                HapticFeedback.medium()
                regionManager.currentRegion = region
                onRegionChanged?()
            }
            dismiss()
        } label: {
            HStack(spacing: AppSpacing.md) {
                Text(region.flag)
                    .font(.largeTitle)

                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                    Text(region.displayName)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text("\(region.currencyCode) (\(region.currencySymbol))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color.accentColor)
                        .font(.title3)
                }
            }
            .padding(.vertical, AppSpacing.xs)
        }
        .accessibilityLabel("\(region.displayName), \(region.currencyCode)")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
