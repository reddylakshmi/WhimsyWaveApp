import SwiftUI

struct AppView: View {
    @Bindable var app: AppReducer

    var body: some View {
        TabView(selection: $app.selectedTab) {
            Tab("tab.home", systemImage: "house", value: .home) {
                HomeView(
                    feature: app.homeFeature,
                    onProductTapped: { app.showingProductDetail = $0 },
                    onCategoryTapped: { category in
                        app.selectedTab = .browse
                        Task { await app.browseFeature.selectCategory(category) }
                    },
                    onSeeAllTapped: { section in
                        switch section.type {
                        case .categories:
                            app.selectedTab = .browse
                        default:
                            app.showingSeeAllProducts = section
                        }
                    },
                    onSearchTapped: { app.showingSearch = true },
                    onNotificationsTapped: { app.showingNotifications = true }
                )
            }

            Tab("tab.browse", systemImage: "square.grid.2x2", value: .browse) {
                BrowseView(
                    feature: app.browseFeature,
                    onProductTapped: { app.showingProductDetail = $0 }
                )
            }

            Tab("tab.cart", systemImage: "cart", value: .cart) {
                CartView(
                    feature: app.cartFeature,
                    onCheckout: {
                        if app.requireAuth(for: .checkout) {
                            app.showingCheckout = true
                        }
                    },
                    onProductTapped: { app.showingProductDetail = $0 }
                )
            }
            .badge(app.cartFeature.cart.itemCount)

            Tab("tab.wishlist", systemImage: "heart", value: .wishlist) {
                WishlistView(
                    feature: app.wishlistFeature,
                    onProductTapped: { app.showingProductDetail = $0 }
                )
            }
            .badge(app.wishlistFeature.items.count)

            Tab("tab.account", systemImage: "person", value: .account) {
                if app.accountFeature.isAuthenticated {
                    AccountView(
                        feature: app.accountFeature,
                        onOrdersTapped: { app.showingOrders = true },
                        onRegionChanged: { app.reloadAllContent() }
                    )
                } else {
                    GuestAccountView(
                        onSignInTapped: { app.showingLogin = true }
                    )
                }
            }
        }
        .onChange(of: app.showingProductDetail) { _, newProduct in
            if let product = newProduct {
                app.productDetailFeature = ProductDetailFeature(product: product)
            }
        }
        .sheet(item: $app.showingProductDetail) { _ in
            if let feature = app.productDetailFeature {
                NavigationStack {
                    ProductDetailView(
                        feature: feature,
                        onCartUpdated: { Task { await app.cartFeature.loadCart() } },
                        onWishlistUpdated: { Task { await app.wishlistFeature.loadWishlist() } }
                    )
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button {
                                    app.showingProductDetail = nil
                                } label: {
                                    HStack(spacing: 4) {
                                        Image(systemName: "chevron.left")
                                        Text("nav.back")
                                    }
                                }
                            }
                        }
                }
            }
        }
        .sheet(item: $app.showingSeeAllProducts) { section in
            NavigationStack {
                ScrollView {
                    ProductGridView(products: section.products, onProductTapped: { product in
                        app.showingSeeAllProducts = nil
                        Task {
                            try? await Task.sleep(for: .milliseconds(300))

                            app.showingProductDetail = product
                        }
                    })
                    .padding(.top, AppSpacing.md)
                    .padding(.bottom, AppSpacing.xl)
                }
                .navigationTitle(section.title)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            app.showingSeeAllProducts = nil
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                Text("nav.back")
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $app.showingCheckout, onDismiss: {
            Task { await app.cartFeature.loadCart() }
        }) {
            CheckoutView(feature: CheckoutFeature(cart: app.cartFeature.cart))
        }
        .sheet(isPresented: $app.showingLogin) {
            NavigationStack {
                VStack(spacing: 0) {
                    if app.pendingAuthAction == .checkout {
                        HStack(spacing: AppSpacing.sm) {
                            Image(systemName: "lock.shield")
                                .foregroundStyle(.blue)
                            Text("auth.signInCheckout")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(AppSpacing.md)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.08))
                    }
                    LoginView(feature: app.accountFeature, onLoginSuccess: {
                        app.handleLoginSuccess()
                    })
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            app.showingLogin = false
                            app.pendingAuthAction = nil
                        } label: {
                            Text("nav.cancel")
                        }
                    }
                }
                .navigationTitle(app.pendingAuthAction == .checkout ? Text("auth.signInToCheckout") : Text("action.signIn"))
                .navigationBarTitleDisplayMode(.inline)
            }
            .presentationDetents([.large])
        }
        .sheet(isPresented: $app.showingSearch) {
            NavigationStack {
                SearchView(
                    feature: app.searchFeature,
                    onProductTapped: { product in
                        app.showingSearch = false
                        Task {
                            try? await Task.sleep(for: .milliseconds(300))

                            app.showingProductDetail = product
                        }
                    }
                )
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            app.showingSearch = false
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                Text("nav.back")
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $app.showingNotifications) {
            NavigationStack {
                NotificationsView(feature: app.notificationsFeature)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                app.showingNotifications = false
                            } label: {
                                HStack(spacing: 4) {
                                    Image(systemName: "chevron.left")
                                    Text("nav.back")
                                }
                            }
                        }
                    }
            }
        }
        .sheet(isPresented: $app.showingOrders) {
            NavigationStack {
                OrdersListView(feature: app.ordersFeature)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                app.showingOrders = false
                            } label: {
                                HStack(spacing: 4) {
                                    Image(systemName: "chevron.left")
                                    Text("nav.back")
                                }
                            }
                        }
                    }
            }
        }
    }
}

// MARK: - Guest Account View (when not signed in)

struct GuestAccountView: View {
    var onSignInTapped: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: AppSpacing.xl) {
                Spacer()

                VStack(spacing: AppSpacing.md) {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 80))
                        .foregroundStyle(.secondary)
                    Text("guest.welcome")
                        .font(.title2.bold())
                    Text("guest.subtitle")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppSpacing.xl)
                }

                Button(action: onSignInTapped) {
                    Text("action.signIn")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppSpacing.md)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Layout.buttonCornerRadius))
                }
                .padding(.horizontal, AppSpacing.xl)

                Spacer()
                Spacer()
            }
            .navigationTitle(Text("tab.account"))
        }
    }
}

extension Product: @retroactive Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
