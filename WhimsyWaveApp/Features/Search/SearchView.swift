import SwiftUI

struct SearchView: View {
    @Bindable var feature: SearchFeature
    @State private var addedProductName: String?
    var onProductTapped: (Product) -> Void = { _ in }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    searchContent
                }
                .zIndex(0)

                if let name = addedProductName {
                    toastView(name: name)
                        .zIndex(1)
                }
            }
            .navigationTitle("Search")
            .searchable(text: $feature.query, prompt: "Search products...")
            .onSubmit(of: .search) {
                Task { await feature.search() }
            }
            .onChange(of: feature.query) {
                Task { await feature.fetchSuggestions() }
            }
            .task { await feature.onAppear() }
        }
    }

    @ViewBuilder
    private var searchContent: some View {
        if feature.isSearching && !feature.results.isEmpty {
            searchResults
        } else if feature.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            preSearchContent
        }
    }

    private var preSearchContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                if !feature.suggestions.isEmpty {
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("Suggestions").font(.headline)
                        ForEach(feature.suggestions, id: \.self) { suggestion in
                            Button {
                                feature.query = suggestion
                                Task { await feature.search() }
                            } label: {
                                HStack {
                                    Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                                    Text(suggestion)
                                    Spacer()
                                    Image(systemName: "arrow.up.left").foregroundStyle(.secondary)
                                }
                                .padding(.vertical, AppSpacing.xs)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                if !feature.recentSearches.isEmpty {
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        HStack {
                            Text("Recent Searches").font(.headline)
                            Spacer()
                            Button("Clear") { Task { await feature.clearRecentSearches() } }
                                .font(.subheadline)
                        }
                        ForEach(feature.recentSearches, id: \.self) { search in
                            Button {
                                feature.query = search
                                Task { await feature.search() }
                            } label: {
                                HStack {
                                    Image(systemName: "clock").foregroundStyle(.secondary)
                                    Text(search)
                                    Spacer()
                                }
                                .padding(.vertical, AppSpacing.xs)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.top, AppSpacing.md)
        }
    }

    private var searchResults: some View {
        ScrollView {
            LazyVStack(spacing: AppSpacing.md) {
                ForEach(feature.results) { product in
                    Button { onProductTapped(product) } label: {
                        searchResultRow(product)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, AppSpacing.md)
        }
    }

    private func searchResultRow(_ product: Product) -> some View {
        HStack(spacing: AppSpacing.md) {
            RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadius)
                .fill(Color.gray.opacity(0.1))
                .frame(width: AppConstants.Image.thumbnailSize, height: AppConstants.Image.thumbnailSize)
                .overlay {
                    Image(systemName: "photo").foregroundStyle(.quaternary)
                }

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(product.name).font(.subheadline).lineLimit(2)
                Text(product.brand).font(.caption).foregroundStyle(.secondary)
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
                }
            }

            Spacer()

            Button {
                Task {
                    await feature.addToCart(product: product)
                    showToast(for: product.name)
                }
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: AppConstants.Layout.minTapTarget, height: AppConstants.Layout.minTapTarget)
                    .background(Circle().fill(.blue))
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, AppSpacing.xs)
    }

    private func toastView(name: String) -> some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
            Text("Added \(name)")
                .lineLimit(1)
        }
        .font(.subheadline.bold())
        .padding(AppSpacing.md)
        .background(.ultraThickMaterial, in: Capsule())
        .padding(.bottom, AppSpacing.xl)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    private func showToast(for name: String) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        withAnimation(.spring(response: AppConstants.Animation.springResponse)) {
            addedProductName = name
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + AppConstants.Animation.toastDisplayDuration) {
            withAnimation(.easeOut) { addedProductName = nil }
        }
    }
}
