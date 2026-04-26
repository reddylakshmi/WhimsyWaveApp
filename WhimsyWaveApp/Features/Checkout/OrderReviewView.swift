import SwiftUI

struct OrderReviewView: View {
    @Bindable var feature: CheckoutFeature

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    if let address = feature.selectedAddress {
                        reviewSection(title: "checkout.shippingAddress", icon: "mappin.circle") {
                            Text(address.fullName).font(.subheadline)
                            Text(address.formattedAddress).font(.subheadline).foregroundStyle(.secondary)
                        }
                    }

                    reviewSection(title: "checkout.delivery", icon: "shippingbox") {
                        Text(feature.selectedDelivery.name).font(.subheadline)
                        Text(feature.selectedDelivery.estimatedDays).font(.caption).foregroundStyle(.secondary)
                    }

                    if let payment = feature.selectedPayment {
                        reviewSection(title: "checkout.payment", icon: "creditcard") {
                            Text(payment.displayName).font(.subheadline)
                        }
                    }

                    reviewSection(title: "checkout.items \(feature.cart.itemCount)", icon: "bag") {
                        ForEach(feature.cart.items) { item in
                            HStack {
                                Text(item.product.name).font(.subheadline).lineLimit(1)
                                Spacer()
                                Text("x\(item.quantity)").font(.caption).foregroundStyle(.secondary)
                                Text(PriceFormatter.format(item.lineTotal)).font(.subheadline)
                            }
                        }
                    }

                    VStack(spacing: AppSpacing.sm) {
                        priceSummaryRow("cart.subtotal", value: feature.subtotal)
                        priceSummaryRow("cart.shipping", value: feature.shippingCost, highlight: feature.shippingCost == 0)
                        priceSummaryRow("cart.tax", value: feature.tax)
                        Divider()
                        HStack {
                            Text("cart.total").font(.headline)
                            Spacer()
                            Text(PriceFormatter.format(feature.total)).font(.title3.bold())
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
                    Text("nav.back")
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
                            Text("checkout.placeOrder")
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

    private func reviewSection<Content: View>(title: LocalizedStringKey, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Label(title, systemImage: icon).font(.headline)
            content()
        }
    }

    private func priceSummaryRow(_ label: LocalizedStringKey, value: Decimal, highlight: Bool = false) -> some View {
        HStack {
            Text(label).font(.subheadline).foregroundStyle(.secondary)
            Spacer()
            Text(highlight && value == 0 ? String(localized: "price.free", locale: RegionManager.shared.currentRegion.locale) : PriceFormatter.format(value))
                .font(.subheadline)
                .foregroundStyle(highlight && value == 0 ? .green : .primary)
        }
    }

}
