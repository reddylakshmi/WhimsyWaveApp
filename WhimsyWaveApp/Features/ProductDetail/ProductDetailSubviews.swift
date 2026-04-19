import SwiftUI

// MARK: - Image Header

struct ProductImageHeader: View {
    let url: String

    var body: some View {
        RemoteImageView(url: url, cornerRadius: AppConstants.Layout.cardCornerRadius)
            .frame(height: AppConstants.Image.productDetailSize)
            .clipped()
    }
}

// MARK: - Info Section (brand, name, price, rating, stock, delivery)

struct ProductInfoSection: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text(product.brand)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(product.name)
                .font(.title2.bold())

            priceRow
            ratingRow
            stockRow

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
    }

    private var priceRow: some View {
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
    }

    private var ratingRow: some View {
        HStack(spacing: AppSpacing.xs) {
            ForEach(1...5, id: \.self) { star in
                Image(systemName: Double(star) <= product.rating ? "star.fill" : (Double(star) - 0.5 <= product.rating ? "star.leadinghalf.filled" : "star"))
                    .foregroundStyle(.orange)
                    .font(.caption)
            }
            Text(String(format: "%.1f", product.rating)).font(.subheadline.bold())
            Text("(\(product.reviewCount) reviews)").font(.subheadline).foregroundStyle(.secondary)
        }
    }

    private var stockRow: some View {
        HStack(spacing: AppSpacing.xs) {
            Image(systemName: product.isInStock ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundStyle(product.isInStock ? .green : .red)
            Text(product.isInStock ? "In Stock" : "Out of Stock")
                .font(.subheadline)
                .foregroundStyle(product.isInStock ? .green : .red)
        }
    }
}

// MARK: - Variant Picker

struct ProductVariantPicker: View {
    let variants: [ProductVariant]
    let selectedVariant: ProductVariant?
    let onSelect: (ProductVariant) -> Void

    var body: some View {
        if !variants.isEmpty {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Options").font(.headline)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppSpacing.sm) {
                        ForEach(variants) { variant in
                            Button { onSelect(variant) } label: {
                                Text(variant.name)
                                    .font(.subheadline)
                                    .padding(.horizontal, AppSpacing.md)
                                    .padding(.vertical, AppSpacing.sm)
                                    .background(
                                        RoundedRectangle(cornerRadius: AppConstants.Layout.buttonCornerRadius)
                                            .fill(selectedVariant?.id == variant.id ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AppConstants.Layout.buttonCornerRadius)
                                            .stroke(selectedVariant?.id == variant.id ? .blue : .clear, lineWidth: 2)
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
    }
}

// MARK: - Quantity Picker

struct ProductQuantityPicker: View {
    let quantity: Int
    let onDecrement: () -> Void
    let onIncrement: () -> Void

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Text("Quantity").font(.headline)
            Spacer()
            HStack(spacing: AppSpacing.md) {
                Button(action: onDecrement) {
                    Image(systemName: "minus")
                        .frame(width: AppConstants.Layout.minTapTarget, height: AppConstants.Layout.minTapTarget)
                        .background(Circle().fill(.ultraThinMaterial))
                }
                .accessibilityLabel("Decrease quantity")
                .accessibilityValue("\(quantity)")
                Text("\(quantity)")
                    .font(.headline.monospacedDigit())
                    .frame(minWidth: 30)
                    .accessibilityHidden(true)
                Button(action: onIncrement) {
                    Image(systemName: "plus")
                        .frame(width: AppConstants.Layout.minTapTarget, height: AppConstants.Layout.minTapTarget)
                        .background(Circle().fill(.ultraThinMaterial))
                }
                .accessibilityLabel("Increase quantity")
                .accessibilityValue("\(quantity)")
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, AppSpacing.md)
    }
}

// MARK: - Description Section

struct ProductDescriptionSection: View {
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Description").font(.headline)
            Text(text)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, AppSpacing.md)
    }
}

// MARK: - Specifications Section

struct ProductSpecsSection: View {
    let specs: [ProductSpec]

    var body: some View {
        if !specs.isEmpty {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Specifications").font(.headline)
                ForEach(specs, id: \.label) { spec in
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
    }
}

// MARK: - Product Detail Skeleton

struct ProductDetailSkeleton: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                SkeletonBox(height: AppConstants.Image.productDetailSize, cornerRadius: AppConstants.Layout.cardCornerRadius)
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    SkeletonBox(width: 80, height: 14)
                    SkeletonBox(height: 22)
                    SkeletonBox(width: 120, height: 20)
                    SkeletonBox(width: 160, height: 14)
                    SkeletonBox(width: 100, height: 14)
                }
                .padding(.horizontal, AppSpacing.md)
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    SkeletonBox(width: 100, height: 18)
                    SkeletonBox(height: 60)
                }
                .padding(.horizontal, AppSpacing.md)
            }
        }
    }
}
