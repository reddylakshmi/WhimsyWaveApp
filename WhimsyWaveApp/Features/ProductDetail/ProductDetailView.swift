import SwiftUI

struct ProductDetailView: View {
    @Bindable var feature: ProductDetailFeature
    var onCartUpdated: () -> Void = {}
    var onWishlistUpdated: () -> Void = {}
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Group {
            if feature.isLoading {
                ProductDetailSkeleton()
            } else if let product = feature.product {
                productContent(product)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { Task { await feature.toggleWishlist(); onWishlistUpdated() } } label: {
                    Image(systemName: feature.isInWishlist ? "heart.fill" : "heart")
                        .foregroundStyle(feature.isInWishlist ? .red : .primary)
                }
                .accessibilityLabel(feature.isInWishlist ? "accessibility.removeFromWishlist" : "accessibility.addToWishlist")
            }
        }
        .overlay(alignment: .bottom) {
            if feature.addedToCart {
                addedToCartToast
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(response: AppConstants.Animation.springResponse), value: feature.addedToCart)
        .errorAlert($feature.error)
        .task { await feature.checkWishlistStatus() }
    }

    private func productContent(_ product: Product) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                ProductImageHeader(url: product.primaryImage)
                ProductInfoSection(product: product)
                ProductVariantPicker(variants: product.variants, selectedVariant: feature.selectedVariant) {
                    feature.selectedVariant = $0
                }
                ProductQuantityPicker(quantity: feature.quantity, onDecrement: feature.decrementQuantity, onIncrement: feature.incrementQuantity)
                ProductDescriptionSection(text: product.description)
                ProductSpecsSection(specs: product.specs)
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
                    Text("product.total")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    if let product = feature.product {
                        Text(PriceFormatter.format(product.effectivePrice * Decimal(feature.quantity)))
                            .font(.title3.bold())
                    }
                }
                Spacer()
                Button {
                    Task {
                        await feature.addToCart()
                        onCartUpdated()
                    }
                } label: {
                    HStack {
                        if feature.isAddingToCart {
                            ProgressView().tint(.white)
                        } else {
                            Image(systemName: "cart.badge.plus")
                            Text("product.addToCart")
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
            Text("product.addedToCart")
        }
        .font(.subheadline.bold())
        .padding(AppSpacing.md)
        .background(.ultraThickMaterial, in: Capsule())
        .padding(.bottom, 80)
    }

}
