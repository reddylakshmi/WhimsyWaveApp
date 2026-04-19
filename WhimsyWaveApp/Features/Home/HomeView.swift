import SwiftUI

struct HomeView: View {
    @Bindable var feature: HomeFeature
    var onProductTapped: (Product) -> Void = { _ in }
    var onCategoryTapped: (Category) -> Void = { _ in }
    var onSeeAllTapped: (HomeSection) -> Void = { _ in }
    var onSearchTapped: () -> Void = {}
    var onNotificationsTapped: () -> Void = {}
    @Environment(\.horizontalSizeClass) private var sizeClass

    var body: some View {
        NavigationStack {
            ScrollView {
                if feature.isLoading && feature.sections.isEmpty {
                    loadingView
                } else if let error = feature.error, feature.sections.isEmpty {
                    errorView(error)
                } else {
                    LazyVStack(spacing: AppSpacing.lg) {
                        ForEach(feature.sections) { section in
                            sectionView(for: section)
                        }
                    }
                    .padding(.vertical, AppSpacing.md)
                }
            }
            .refreshable { await feature.refresh() }
            .navigationTitle("Whimsy Wave")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: AppSpacing.sm) {
                        Button(action: onSearchTapped) {
                            Image(systemName: "magnifyingglass")
                        }
                        .accessibilityLabel("Search products")

                        Button(action: onNotificationsTapped) {
                            Image(systemName: "bell")
                        }
                        .accessibilityLabel("Notifications")
                    }
                }
            }
            .task { await feature.onAppear() }
        }
    }

    @ViewBuilder
    private func sectionView(for section: HomeSection) -> some View {
        switch section.type {
        case .heroBanner:
            bannerCarousel(section.banners)
        case .categories:
            categoriesGrid(section)
        default:
            productSection(section)
        }
    }

    private func bannerCarousel(_ banners: [Banner]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.md) {
                ForEach(banners) { banner in
                    ZStack(alignment: .bottomLeading) {
                        RemoteImageView(
                            url: banner.imageURL,
                            cornerRadius: AppConstants.Layout.cardCornerRadius
                        )
                        .frame(width: sizeClass == .regular ? 420 : 300, height: AppConstants.Image.bannerHeight)

                        LinearGradient(
                            colors: [.black.opacity(0.6), .clear],
                            startPoint: .bottom,
                            endPoint: .center
                        )
                        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Layout.cardCornerRadius))

                        VStack(alignment: .leading, spacing: 4) {
                            Text(banner.title)
                                .font(.title3.bold())
                                .foregroundStyle(.white)
                            Text(banner.subtitle)
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.85))
                        }
                        .padding(AppSpacing.md)
                    }
                    .frame(width: sizeClass == .regular ? 420 : 300, height: AppConstants.Image.bannerHeight)
                }
            }
            .padding(.horizontal, AppSpacing.md)
        }
    }

    private func categoriesGrid(_ section: HomeSection) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            sectionHeader(section)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.md) {
                    ForEach(section.categories) { category in
                        Button { onCategoryTapped(category) } label: {
                            VStack(spacing: AppSpacing.xs) {
                                Image(systemName: category.image)
                                    .font(.title2)
                                    .frame(width: 56, height: 56)
                                    .background(Circle().fill(.ultraThinMaterial))
                                Text(category.name)
                                    .font(.caption)
                                    .foregroundStyle(.primary)
                            }
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Browse \(category.name)")
                    }
                }
                .padding(.horizontal, AppSpacing.md)
            }
        }
    }

    private func productSection(_ section: HomeSection) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            sectionHeader(section)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.md) {
                    ForEach(section.products) { product in
                        Button { onProductTapped(product) } label: {
                            productCard(product)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, AppSpacing.md)
            }
        }
    }

    private func sectionHeader(_ section: HomeSection) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(section.title)
                    .font(.title3.bold())
                if let subtitle = section.subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Button("See All") { onSeeAllTapped(section) }
                .font(.subheadline.bold())
        }
        .padding(.horizontal, AppSpacing.md)
    }

    private func productCard(_ product: Product) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            RemoteImageView(url: product.primaryImage, cornerRadius: AppConstants.Layout.cornerRadius)
                .frame(width: sizeClass == .regular ? 200 : 160, height: sizeClass == .regular ? 200 : 160)

            Text(product.brand)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(product.name)
                .font(.subheadline)
                .lineLimit(2)
            HStack(spacing: AppSpacing.xs) {
                if product.isOnSale, let saleDisplay = product.displaySalePrice {
                    Text(saleDisplay)
                        .font(.subheadline.bold())
                        .foregroundStyle(.red)
                    Text(product.displayPrice)
                        .font(.caption)
                        .strikethrough()
                        .foregroundStyle(.secondary)
                } else {
                    Text(product.displayPrice)
                        .font(.subheadline.bold())
                }
            }
            HStack(spacing: 2) {
                Image(systemName: "star.fill")
                    .font(.caption2)
                    .foregroundStyle(.orange)
                Text(String(format: "%.1f", product.rating))
                    .font(.caption)
                Text("(\(product.reviewCount))")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: sizeClass == .regular ? 200 : 160)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(product.name) by \(product.brand), \(product.displayPrice)\(product.isOnSale ? ", on sale" : ""), rated \(String(format: "%.1f", product.rating)) stars")
        .accessibilityHint("Double tap to view product details")
    }

    private var loadingView: some View {
        VStack(spacing: AppSpacing.md) {
            ForEach(0..<3, id: \.self) { _ in
                RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadius)
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 200)
                    .padding(.horizontal, AppSpacing.md)
            }
        }
        .redacted(reason: .placeholder)
    }

    private func errorView(_ message: String) -> some View {
        ContentUnavailableView {
            Label("Something Went Wrong", systemImage: "exclamationmark.triangle")
        } description: {
            Text(message)
        } actions: {
            Button("Try Again") { Task { await feature.refresh() } }
                .buttonStyle(.borderedProminent)
        }
    }
}

