import SwiftUI

struct ProductGridView: View {
    let products: [Product]
    var onProductTapped: (Product) -> Void = { _ in }

    private let columns = [
        GridItem(.flexible(), spacing: AppSpacing.md),
        GridItem(.flexible(), spacing: AppSpacing.md)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: AppSpacing.md) {
            ForEach(products) { product in
                Button { onProductTapped(product) } label: {
                    ProductGridCard(product: product)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, AppSpacing.md)
    }
}

struct ProductGridCard: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadius)
                .fill(Color.gray.opacity(0.1))
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundStyle(.quaternary)
                }
                .overlay(alignment: .topTrailing) {
                    if product.isOnSale, let discount = product.discountPercentage {
                        Text("-\(discount)%")
                            .font(.caption2.bold())
                            .padding(.horizontal, AppSpacing.sm)
                            .padding(.vertical, AppSpacing.xxs)
                            .background(Capsule().fill(.red))
                            .foregroundStyle(.white)
                            .padding(AppSpacing.sm)
                    }
                }

            Text(product.brand)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(product.name)
                .font(.subheadline)
                .lineLimit(2)
            HStack(spacing: AppSpacing.xs) {
                if product.isOnSale, let sale = product.displaySalePrice {
                    Text(sale).font(.subheadline.bold()).foregroundStyle(.red)
                    Text(product.displayPrice).font(.caption).strikethrough().foregroundStyle(.secondary)
                } else {
                    Text(product.displayPrice).font(.subheadline.bold())
                }
            }
            HStack(spacing: 2) {
                Image(systemName: "star.fill").font(.caption2).foregroundStyle(.orange)
                Text(String(format: "%.1f", product.rating)).font(.caption)
                Text("(\(product.reviewCount))").font(.caption2).foregroundStyle(.secondary)
            }
        }
    }
}
