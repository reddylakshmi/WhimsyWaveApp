import SwiftUI

struct OrderDetailView: View {
    let order: Order
    var onCancel: () -> Void = {}
    @State private var showingCancelConfirmation = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                // Status
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text(order.status.displayName)
                        .font(.title2.bold())
                    if order.status != .cancelled && order.status != .returned {
                        ProgressView(value: order.status.progressValue)
                            .tint(.blue)
                    }
                    if let tracking = order.trackingNumber {
                        HStack {
                            Text("order.tracking").font(.subheadline).foregroundStyle(.secondary)
                            Text(tracking).font(.subheadline.monospaced())
                        }
                    }
                }

                // Items
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text("order.items").font(.headline)
                    ForEach(order.items) { item in
                        HStack(spacing: AppSpacing.md) {
                            RemoteImageView(url: item.image, cornerRadius: AppConstants.Layout.cornerRadius)
                                .frame(width: 50, height: 50)
                            VStack(alignment: .leading) {
                                Text(item.name).font(.subheadline).lineLimit(1)
                                Text("order.quantity \(item.quantity)").font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(PriceFormatter.format(item.lineTotal)).font(.subheadline)
                        }
                    }
                }

                // Shipping
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text("checkout.shippingAddress").font(.headline)
                    Text(order.shippingAddress.fullName).font(.subheadline)
                    Text(order.shippingAddress.formattedAddress).font(.subheadline).foregroundStyle(.secondary)
                }

                // Summary
                VStack(spacing: AppSpacing.sm) {
                    priceSummaryRow("cart.subtotal", value: order.subtotal)
                    priceSummaryRow("cart.shipping", value: order.shippingCost)
                    priceSummaryRow("cart.tax", value: order.tax)
                    Divider()
                    HStack {
                        Text("cart.total").font(.headline)
                        Spacer()
                        Text(order.displayTotal).font(.headline)
                    }
                }

                // Cancel
                if order.status == .placed || order.status == .confirmed {
                    Button(role: .destructive) {
                        showingCancelConfirmation = true
                    } label: {
                        Text("order.cancelOrder")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AppSpacing.md)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding(AppSpacing.md)
        }
        .navigationTitle("order.number \(order.orderNumber)")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("order.cancelOrder", isPresented: $showingCancelConfirmation, titleVisibility: .visible) {
            Button("order.cancelOrder", role: .destructive) {
                HapticFeedback.medium()
                onCancel()
            }
            Button("order.keepOrder", role: .cancel) {}
        } message: {
            Text("order.cancelConfirmation")
        }
    }

    private func priceSummaryRow(_ label: LocalizedStringKey, value: Decimal) -> some View {
        HStack {
            Text(label).font(.subheadline).foregroundStyle(.secondary)
            Spacer()
            Text(value == 0 ? String(localized: "price.free", locale: RegionManager.shared.currentRegion.locale) : PriceFormatter.format(value)).font(.subheadline)
        }
    }

}
