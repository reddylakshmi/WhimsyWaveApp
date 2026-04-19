import SwiftUI

struct OrderReviewView: View {
    @Bindable var feature: CheckoutFeature

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    if let address = feature.selectedAddress {
                        reviewSection(title: "Shipping Address", icon: "mappin.circle") {
                            Text(address.fullName).font(.subheadline)
                            Text(address.formattedAddress).font(.subheadline).foregroundStyle(.secondary)
                        }
                    }

                    reviewSection(title: "Delivery", icon: "shippingbox") {
                        Text(feature.selectedDelivery.name).font(.subheadline)
                        Text(feature.selectedDelivery.estimatedDays).font(.caption).foregroundStyle(.secondary)
                    }

                    if let payment = feature.selectedPayment {
                        reviewSection(title: "Payment", icon: "creditcard") {
                            Text(payment.displayName).font(.subheadline)
                        }
                    }

                    reviewSection(title: "Items (\(feature.cart.itemCount))", icon: "bag") {
                        ForEach(feature.cart.items) { item in
                            HStack {
                                Text(item.product.name).font(.subheadline).lineLimit(1)
                                Spacer()
                                Text("x\(item.quantity)").font(.caption).foregroundStyle(.secondary)
                                Text(formatPrice(item.lineTotal)).font(.subheadline)
                            }
                        }
                    }

                    VStack(spacing: AppSpacing.sm) {
                        priceRow("Subtotal", value: feature.subtotal)
                        priceRow("Shipping", value: feature.shippingCost, highlight: feature.shippingCost == 0)
                        priceRow("Tax", value: feature.tax)
                        Divider()
                        HStack {
                            Text("Total").font(.headline)
                            Spacer()
                            Text(formatPrice(feature.total)).font(.title3.bold())
                        }
                    }
                    .padding(AppSpacing.md)
                    .background(RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadius).fill(.ultraThinMaterial))
                }
                .padding(AppSpacing.md)
            }
            Spacer()
            HStack(spacing: AppSpacing.md) {
                Button { feature.previousStep() } label: {
                    Text("Back")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppSpacing.md)
                        .background(RoundedRectangle(cornerRadius: AppConstants.Layout.buttonCornerRadius).stroke(.blue))
                }
                Button {
                    Task { await feature.placeOrder() }
                } label: {
                    HStack {
                        if feature.isPlacingOrder {
                            ProgressView().tint(.white)
                        } else {
                            Text("Place Order")
                        }
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.md)
                    .background(RoundedRectangle(cornerRadius: AppConstants.Layout.buttonCornerRadius).fill(.blue))
                }
                .disabled(feature.isPlacingOrder)
            }
            .padding(AppSpacing.md)
        }
    }

    private func reviewSection<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Label(title, systemImage: icon).font(.headline)
            content()
        }
    }

    private func priceRow(_ label: String, value: Decimal, highlight: Bool = false) -> some View {
        HStack {
            Text(label).font(.subheadline).foregroundStyle(.secondary)
            Spacer()
            Text(highlight && value == 0 ? "FREE" : formatPrice(value))
                .font(.subheadline)
                .foregroundStyle(highlight && value == 0 ? .green : .primary)
        }
    }

    private func formatPrice(_ value: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: value as NSDecimalNumber) ?? "$0.00"
    }
}
