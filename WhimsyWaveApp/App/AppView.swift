import SwiftUI

struct AppView: View {
    @Bindable var app: AppReducer

    var body: some View {
        TabView(selection: $app.selectedTab) {
            Tab("Home", systemImage: "house", value: .home) {
                HomeView(
                    feature: app.homeFeature,
                    onProductTapped: { app.showingProductDetail = $0 },
                    onSearchTapped: { app.showingSearch = true },
                    onNotificationsTapped: { app.showingNotifications = true }
                )
            }

            Tab("Browse", systemImage: "square.grid.2x2", value: .browse) {
                BrowseView(
                    feature: app.browseFeature,
                    onProductTapped: { app.showingProductDetail = $0 }
                )
            }

            Tab("Cart", systemImage: "cart", value: .cart) {
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

            Tab("Wishlist", systemImage: "heart", value: .wishlist) {
                WishlistView(
                    feature: app.wishlistFeature,
                    onProductTapped: { app.showingProductDetail = $0 }
                )
            }

            Tab("Profile", systemImage: "person", value: .profile) {
                if app.profileFeature.isAuthenticated {
                    ProfileView(
                        feature: app.profileFeature,
                        onOrdersTapped: { app.showingOrders = true }
                    )
                } else {
                    GuestProfileView(
                        onSignInTapped: { app.showingLogin = true }
                    )
                }
            }
        }
        .sheet(item: $app.showingProductDetail) { product in
            NavigationStack {
                ProductDetailView(feature: ProductDetailFeature(product: product))
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Close") {
                                app.showingProductDetail = nil
                            }
                        }
                    }
            }
        }
        .sheet(isPresented: $app.showingCheckout) {
            CheckoutView(feature: CheckoutFeature(cart: app.cartFeature.cart))
        }
        .sheet(isPresented: $app.showingLogin) {
            NavigationStack {
                VStack(spacing: 0) {
                    if app.pendingAuthAction == .checkout {
                        HStack(spacing: AppSpacing.sm) {
                            Image(systemName: "lock.shield")
                                .foregroundStyle(.blue)
                            Text("Sign in to complete your purchase")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(AppSpacing.md)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.08))
                    }
                    LoginView(feature: app.profileFeature, onLoginSuccess: {
                        app.handleLoginSuccess()
                    })
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            app.showingLogin = false
                            app.pendingAuthAction = nil
                        }
                    }
                }
                .navigationTitle(app.pendingAuthAction == .checkout ? "Sign In to Checkout" : "Sign In")
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            app.showingProductDetail = product
                        }
                    }
                )
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Close") { app.showingSearch = false }
                    }
                }
            }
        }
        .sheet(isPresented: $app.showingNotifications) {
            NavigationStack {
                NotificationsView(feature: app.notificationsFeature)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Close") { app.showingNotifications = false }
                        }
                    }
            }
        }
        .sheet(isPresented: $app.showingOrders) {
            NavigationStack {
                OrdersListView(feature: app.ordersFeature)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Close") { app.showingOrders = false }
                        }
                    }
            }
        }
    }
}

// MARK: - Guest Profile View (when not signed in)

struct GuestProfileView: View {
    var onSignInTapped: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: AppSpacing.xl) {
                Spacer()

                VStack(spacing: AppSpacing.md) {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 80))
                        .foregroundStyle(.secondary)
                    Text("Welcome to Whimsy Wave")
                        .font(.title2.bold())
                    Text("Sign in to track orders, save favorites, and get personalized recommendations.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppSpacing.xl)
                }

                Button(action: onSignInTapped) {
                    Text("Sign In")
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
            .navigationTitle("Profile")
        }
    }
}

extension Product: @retroactive Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
