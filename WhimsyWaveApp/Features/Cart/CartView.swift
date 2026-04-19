import SwiftUI

struct CartView: View {
    @Bindable var feature: CartFeature
    var onCheckout: () -> Void = {}
    var onProductTapped: (Product) -> Void = { _ in }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if feature.cart.isEmpty && !feature.isLoading {
                    ContentUnavailableView("Your cart is empty", systemImage: "cart", description: Text("Items you add will appear here"))
                } else if feature.isLoading && feature.cart.isEmpty {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    cartContent
                }
            }
            .navigationTitle("Cart")
            .task { await feature.loadCart() }
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
                        onRemove: { Task { await feature.removeItem(item) } },
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
                    Text("Total (\(feature.cart.itemCount) items)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(feature.cart.displayTotal)
                        .font(.title3.bold())
                }
                Spacer()
                Button(action: onCheckout) {
                    Text("Checkout")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(minWidth: 140)
                        .padding(.vertical, AppSpacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: AppConstants.Layout.buttonCornerRadius)
                                .fill(.blue)
                        )
                }
                .accessibilityLabel("Checkout, \(feature.cart.itemCount) items, \(feature.cart.displayTotal)")
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
                RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadius)
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 70, height: 70)
                    .overlay {
                        Image(systemName: "photo").foregroundStyle(.quaternary)
                    }
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
                        .accessibilityLabel("Decrease quantity of \(item.product.name)")
                        .accessibilityValue("\(item.quantity)")

                        Text("\(item.quantity)")
                            .font(.subheadline.bold().monospacedDigit())
                            .accessibilityHidden(true)

                        Button(action: onIncrement) {
                            Image(systemName: "plus")
                                .font(.caption.bold())
                        }
                        .buttonStyle(.borderless)
                        .accessibilityLabel("Increase quantity of \(item.product.name)")
                        .accessibilityValue("\(item.quantity)")
                    }
                    .padding(.horizontal, AppSpacing.sm)
                    .padding(.vertical, AppSpacing.xs)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 6))

                    Spacer()

                    Text(formatPrice(item.lineTotal))
                        .font(.subheadline.bold())
                }
            }
        }
        .padding(.vertical, AppSpacing.xs)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive, action: onRemove) {
                Label("Remove", systemImage: "trash")
            }
        }
    }

    private func formatPrice(_ value: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: value as NSDecimalNumber) ?? "$0.00"
    }
}
