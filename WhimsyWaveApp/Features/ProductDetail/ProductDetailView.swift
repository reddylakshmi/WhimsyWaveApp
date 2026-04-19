import SwiftUI

struct ProductDetailView: View {
    @Bindable var feature: ProductDetailFeature
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Group {
            if feature.isLoading {
                ProgressView()
            } else if let product = feature.product {
                productContent(product)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { Task { await feature.toggleWishlist() } } label: {
                    Image(systemName: feature.isInWishlist ? "heart.fill" : "heart")
                        .foregroundStyle(feature.isInWishlist ? .red : .primary)
                }
                .accessibilityLabel(feature.isInWishlist ? "Remove from wishlist" : "Add to wishlist")
            }
        }
        .overlay(alignment: .bottom) {
            if feature.addedToCart {
                addedToCartToast
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(response: AppConstants.Animation.springResponse), value: feature.addedToCart)
    }

    private func productContent(_ product: Product) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                // Image area
                RoundedRectangle(cornerRadius: AppConstants.Layout.cardCornerRadius)
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: AppConstants.Image.productDetailSize)
                    .overlay {
                        Image(systemName: "photo")
                            .font(.system(size: 60))
                            .foregroundStyle(.quaternary)
                    }

                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text(product.brand)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(product.name)
                        .font(.title2.bold())

                    // Price
                    HStack(spacing: AppSpacing.sm) {
                        if product.isOnSale, let sale = product.displaySalePrice {
                            Text(sale).font(.title3.bold()).foregroundStyle(.red)
                            Text(product.displayPrice).font(.body).strikethrough().foregroundStyle(.secondary)
                            if let discount = product.discountPercentage {
                                Text("\(discount)% off")
                                    .font(.caption.bold())
                                    .padding(.horizontal, AppSpacing.sm)
                                    .padding(.vertical, AppSpacing.xxs)
                                    .background(Capsule().fill(.red.opacity(0.1)))
                                    .foregroundStyle(.red)
                            }
                        } else {
                            Text(product.displayPrice).font(.title3.bold())
                        }
                    }

                    // Rating
                    HStack(spacing: AppSpacing.xs) {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: Double(star) <= product.rating ? "star.fill" : (Double(star) - 0.5 <= product.rating ? "star.leadinghalf.filled" : "star"))
                                .foregroundStyle(.orange)
                                .font(.caption)
                        }
                        Text(String(format: "%.1f", product.rating)).font(.subheadline.bold())
                        Text("(\(product.reviewCount) reviews)").font(.subheadline).foregroundStyle(.secondary)
                    }

                    // Stock
                    HStack(spacing: AppSpacing.xs) {
                        Image(systemName: product.isInStock ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundStyle(product.isInStock ? .green : .red)
                        Text(product.isInStock ? "In Stock" : "Out of Stock")
                            .font(.subheadline)
                            .foregroundStyle(product.isInStock ? .green : .red)
                    }

                    if let delivery = product.estimatedDelivery {
                        HStack(spacing: AppSpacing.xs) {
                            Image(systemName: "shippingbox")
                            Text("Delivery \(delivery.earliest.formatted(.dateTime.month().day())) - \(delivery.latest.formatted(.dateTime.month().day()))")
                                .font(.subheadline)
                        }
                        .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, AppSpacing.md)

                // Variants
                if !product.variants.isEmpty {
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("Options").font(.headline)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AppSpacing.sm) {
                                ForEach(product.variants) { variant in
                                    Button {
                                        feature.selectedVariant = variant
                                    } label: {
                                        Text(variant.name)
                                            .font(.subheadline)
                                            .padding(.horizontal, AppSpacing.md)
                                            .padding(.vertical, AppSpacing.sm)
                                            .background(
                                                RoundedRectangle(cornerRadius: AppConstants.Layout.buttonCornerRadius)
                                                    .fill(feature.selectedVariant?.id == variant.id ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: AppConstants.Layout.buttonCornerRadius)
                                                    .stroke(feature.selectedVariant?.id == variant.id ? .blue : .clear, lineWidth: 2)
                                            )
                                    }
                                    .buttonStyle(.plain)
                                    .disabled(!variant.isInStock)
                                    .opacity(variant.isInStock ? 1 : 0.5)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, AppSpacing.md)
                }

                // Quantity
                HStack(spacing: AppSpacing.md) {
                    Text("Quantity").font(.headline)
                    Spacer()
                    HStack(spacing: AppSpacing.md) {
                        Button { feature.decrementQuantity() } label: {
                            Image(systemName: "minus")
                                .frame(width: AppConstants.Layout.minTapTarget, height: AppConstants.Layout.minTapTarget)
                                .background(Circle().fill(.ultraThinMaterial))
                        }
                        .accessibilityLabel("Decrease quantity")
                        .accessibilityValue("\(feature.quantity)")
                        Text("\(feature.quantity)")
                            .font(.headline.monospacedDigit())
                            .frame(minWidth: 30)
                            .accessibilityHidden(true)
                        Button { feature.incrementQuantity() } label: {
                            Image(systemName: "plus")
                                .frame(width: AppConstants.Layout.minTapTarget, height: AppConstants.Layout.minTapTarget)
                                .background(Circle().fill(.ultraThinMaterial))
                        }
                        .accessibilityLabel("Increase quantity")
                        .accessibilityValue("\(feature.quantity)")
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, AppSpacing.md)

                // Description
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text("Description").font(.headline)
                    Text(product.description)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, AppSpacing.md)

                // Specs
                if !product.specs.isEmpty {
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("Specifications").font(.headline)
                        ForEach(product.specs, id: \.label) { spec in
                            HStack {
                                Text(spec.label).foregroundStyle(.secondary)
                                Spacer()
                                Text(spec.value)
                            }
                            .font(.subheadline)
                            Divider()
                        }
                    }
                    .padding(.horizontal, AppSpacing.md)
                }

                Spacer(minLength: 100)
            }
        }
        .safeAreaInset(edge: .bottom) {
            addToCartBar
        }
    }

    private var addToCartBar: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: AppSpacing.md) {
                VStack(alignment: .leading) {
                    Text("Total")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    if let product = feature.product {
                        Text(formatPrice(product.effectivePrice * Decimal(feature.quantity)))
                            .font(.title3.bold())
                    }
                }
                Spacer()
                Button {
                    Task { await feature.addToCart() }
                } label: {
                    HStack {
                        if feature.isAddingToCart {
                            ProgressView().tint(.white)
                        } else {
                            Image(systemName: "cart.badge.plus")
                            Text("Add to Cart")
                        }
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(minWidth: 160)
                    .padding(.vertical, AppSpacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: AppConstants.Layout.buttonCornerRadius)
                            .fill(feature.product?.isInStock == true ? .blue : .gray)
                    )
                }
                .disabled(feature.isAddingToCart || feature.product?.isInStock != true)
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
            .background(.ultraThinMaterial)
        }
    }

    private var addedToCartToast: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
            Text("Added to cart")
        }
        .font(.subheadline.bold())
        .padding(AppSpacing.md)
        .background(.ultraThickMaterial, in: Capsule())
        .padding(.bottom, 80)
    }

    private func formatPrice(_ value: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: value as NSDecimalNumber) ?? "$0.00"
    }
}
