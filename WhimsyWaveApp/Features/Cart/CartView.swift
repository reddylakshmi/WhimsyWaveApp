import SwiftUI

struct CartView: View {
    @Bindable var feature: CartFeature
    var onCheckout: () -> Void = {}
    var onProductTapped: (Product) -> Void = { _ in }
    @State private var itemToRemove: CartItem?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if feature.cart.isEmpty && !feature.isLoading {
                    ContentUnavailableView("cart.empty.title", systemImage: "cart", description: Text("cart.empty.description"))
                } else if feature.isLoading && feature.cart.isEmpty {
                    CartSkeleton()
                } else {
                    cartContent
                }
            }
            .navigationTitle("tab.cart")
            .refreshable { await feature.loadCart() }
            .task { await feature.loadCart() }
            .errorAlert($feature.error)
            .confirmationDialog("cart.removeItem", isPresented: Binding(
                get: { itemToRemove != nil },
                set: { if !$0 { itemToRemove = nil } }
            ), titleVisibility: .visible) {
                Button("cart.remove", role: .destructive) {
                    if let item = itemToRemove {
                        HapticFeedback.medium()
                        Task { await feature.removeItem(item) }
                    }
                }
                Button("nav.cancel", role: .cancel) { itemToRemove = nil }
            } message: {
                if let item = itemToRemove {
                    Text("cart.removeConfirmation \(item.product.name)")
                }
            }
        }
    }

    private var cartContent: some View {
        VStack(spacing: 0) {
            List {
                ForEach(feature.cart.items) { item in
                    CartItemRow(
                        item: item,
                        onIncrement: { Task { await feature.incrementQuantity(item) } },
                        onDecrement: { Task { await feature.decrementQuantity(item) } },
                        onRemove: { itemToRemove = item },
                        onTap: { onProductTapped(item.product) }
                    )
                }
            }
            .listStyle(.plain)

            checkoutBar
        }
    }

    private var checkoutBar: some View {
        VStack(spacing: AppSpacing.sm) {
            Divider()
            HStack {
                VStack(alignment: .leading) {
                    Text("cart.totalItems \(feature.cart.itemCount)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(feature.cart.displayTotal)
                        .font(.title3.bold())
                }
                Spacer()
                Button(action: onCheckout) {
                    Text("action.checkout")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(minWidth: 140)
                        .padding(.vertical, AppSpacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: AppConstants.Layout.buttonCornerRadius)
                                .fill(.blue)
                        )
                }
                .accessibilityLabel("action.checkout")
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.bottom, AppSpacing.sm)
        }
        .background(.ultraThinMaterial)
    }
}

struct CartItemRow: View {
    let item: CartItem
    let onIncrement: () -> Void
    let onDecrement: () -> Void
    let onRemove: () -> Void
    let onTap: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: AppSpacing.md) {
            Button(action: onTap) {
                RemoteImageView(url: item.product.primaryImage, cornerRadius: AppConstants.Layout.cornerRadius)
                    .frame(width: 70, height: 70)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text(item.product.name)
                    .font(.subheadline)
                    .lineLimit(2)

                if let variant = item.selectedVariant {
                    Text(variant.name)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                HStack {
                    HStack(spacing: AppSpacing.md) {
                        Button(action: onDecrement) {
                            Image(systemName: "minus")
                                .font(.caption.bold())
                        }
                        .buttonStyle(.borderless)
                        .accessibilityLabel("accessibility.decreaseQuantity \(item.product.name)")
                        .accessibilityValue("\(item.quantity)")

                        Text("\(item.quantity)")
                            .font(.subheadline.bold().monospacedDigit())
                            .accessibilityHidden(true)

                        Button(action: onIncrement) {
                            Image(systemName: "plus")
                                .font(.caption.bold())
                        }
                        .buttonStyle(.borderless)
                        .accessibilityLabel("accessibility.increaseQuantity \(item.product.name)")
                        .accessibilityValue("\(item.quantity)")
                    }
                    .padding(.horizontal, AppSpacing.sm)
                    .padding(.vertical, AppSpacing.xs)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 6))

                    Spacer()

                    Text(PriceFormatter.format(item.lineTotal))
                        .font(.subheadline.bold())
                }
            }
        }
        .padding(.vertical, AppSpacing.xs)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive, action: onRemove) {
                Label("cart.remove", systemImage: "trash")
            }
        }
    }

}
