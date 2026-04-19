import SwiftUI

struct OrderDetailView: View {
    let order: Order
    var onCancel: () -> Void = {}

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
                            Text(formatPrice(item.lineTotal)).font(.subheadline)
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
                    Button(role: .destructive, action: onCancel) {
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
    }

    private func priceRow(_ label: String, value: Decimal) -> some View {
        HStack {
            Text(label).font(.subheadline).foregroundStyle(.secondary)
            Spacer()
            Text(value == 0 ? "FREE" : formatPrice(value)).font(.subheadline)
        }
    }

    private func formatPrice(_ value: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: value as NSDecimalNumber) ?? "$0.00"
    }
}
