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
                            Text("Tracking:").font(.subheadline).foregroundStyle(.secondary)
                            Text(tracking).font(.subheadline.monospaced())
                        }
                    }
                }

                // Items
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text("Items").font(.headline)
                    ForEach(order.items) { item in
                        HStack(spacing: AppSpacing.md) {
                            RemoteImageView(url: item.image, cornerRadius: AppConstants.Layout.cornerRadius)
                                .frame(width: 50, height: 50)
                            VStack(alignment: .leading) {
                                Text(item.name).font(.subheadline).lineLimit(1)
                                Text("Qty: \(item.quantity)").font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(PriceFormatter.format(item.lineTotal)).font(.subheadline)
                        }
                    }
                }

                // Shipping
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text("Shipping Address").font(.headline)
                    Text(order.shippingAddress.fullName).font(.subheadline)
                    Text(order.shippingAddress.formattedAddress).font(.subheadline).foregroundStyle(.secondary)
                }

                // Summary
                VStack(spacing: AppSpacing.sm) {
                    priceRow("Subtotal", value: order.subtotal)
                    priceRow("Shipping", value: order.shippingCost)
                    priceRow("Tax", value: order.tax)
                    Divider()
                    HStack {
                        Text("Total").font(.headline)
                        Spacer()
                        Text(order.displayTotal).font(.headline)
                    }
                }

                // Cancel
                if order.status == .placed || order.status == .confirmed {
                    Button(role: .destructive) {
                        showingCancelConfirmation = true
                    } label: {
                        Text("Cancel Order")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AppSpacing.md)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding(AppSpacing.md)
        }
        .navigationTitle("Order #\(order.orderNumber)")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Cancel Order", isPresented: $showingCancelConfirmation, titleVisibility: .visible) {
            Button("Cancel Order", role: .destructive) {
                HapticFeedback.medium()
                onCancel()
            }
            Button("Keep Order", role: .cancel) {}
        } message: {
            Text("Are you sure you want to cancel this order? This action cannot be undone.")
        }
    }

    private func priceRow(_ label: String, value: Decimal) -> some View {
        HStack {
            Text(label).font(.subheadline).foregroundStyle(.secondary)
            Spacer()
            Text(value == 0 ? "FREE" : PriceFormatter.format(value)).font(.subheadline)
        }
    }

}
