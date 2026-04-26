import SwiftUI

struct WishlistView: View {
    @Bindable var feature: WishlistFeature
    var onProductTapped: (Product) -> Void = { _ in }

    var body: some View {
        NavigationStack {
            Group {
                if feature.isLoading && feature.items.isEmpty {
                    ProgressView()
                } else if feature.items.isEmpty {
                    ContentUnavailableView("wishlist.empty.title", systemImage: "heart", description: Text("wishlist.empty.description"))
                } else {
                    List(feature.items) { item in
                        HStack(spacing: AppSpacing.md) {
                            Button { onProductTapped(item.product) } label: {
                                RemoteImageView(url: item.product.primaryImage, cornerRadius: AppConstants.Layout.cornerRadius)
                                    .frame(width: 70, height: 70)
                            }
                            .buttonStyle(.plain)

                            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                                Text(item.product.name).font(.subheadline).lineLimit(2)
                                Text(item.product.brand).font(.caption).foregroundStyle(.secondary)
                                HStack {
                                    Text(item.product.displayPrice).font(.subheadline.bold())
                                    if item.hasPriceDropped {
                                        Text("wishlist.priceDropped")
                                            .font(.caption2)
                                            .foregroundStyle(.green)
                                    }
                                }
                            }

                            Spacer()

                            Button {
                                Task { await feature.moveToCart(item) }
                            } label: {
                                Image(systemName: "cart.badge.plus")
                                    .frame(width: AppConstants.Layout.minTapTarget, height: AppConstants.Layout.minTapTarget)
                            }
                            .buttonStyle(.borderless)
                            .accessibilityLabel("accessibility.moveToCart \(item.product.name)")
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityHint(Text("accessibility.wishlistItemHint"))
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                Task { await feature.removeItem(productId: item.product.id) }
                            } label: {
                                Label("action.remove", systemImage: "trash")
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("tab.wishlist")
            .refreshable { await feature.loadWishlist() }
            .task { await feature.loadWishlist() }
            .errorAlert($feature.error)
        }
    }
}
