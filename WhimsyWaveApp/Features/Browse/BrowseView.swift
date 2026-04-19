import SwiftUI

struct BrowseView: View {
    @Bindable var feature: BrowseFeature
    var onProductTapped: (Product) -> Void = { _ in }

    var body: some View {
        NavigationStack {
            if feature.isLoading && feature.categories.isEmpty {
                ScrollView {
                    ProductGridSkeleton()
                        .padding(.top, AppSpacing.md)
                }
                .navigationTitle("Browse")
            } else {
                ScrollView {
                    LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                        Section {
                            productContent
                        } header: {
                            VStack(spacing: 0) {
                                categoryBar
                                Divider()
                            }
                            .background(.background)
                        }
                    }
                }
                .refreshable { await feature.refresh() }
                .navigationTitle("Browse")
            }
        }
        .task { await feature.loadCategories() }
        .errorAlert($feature.error)
    }

    private var categoryBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.sm) {
                ForEach(feature.categories) { category in
                    Button {
                        Task { await feature.selectCategory(category) }
                    } label: {
                        VStack(spacing: AppSpacing.xs) {
                            Image(systemName: category.image)
                                .font(.title3)
                                .frame(width: 48, height: 48)
                                .background(
                                    Circle().fill(
                                        feature.selectedCategory?.id == category.id
                                            ? Color.accentColor.opacity(0.15)
                                            : Color.gray.opacity(0.1)
                                    )
                                )
                                .foregroundStyle(
                                    feature.selectedCategory?.id == category.id
                                        ? Color.accentColor
                                        : .primary
                                )
                            Text(category.name)
                                .font(.caption2)
                                .foregroundStyle(
                                    feature.selectedCategory?.id == category.id
                                        ? Color.accentColor
                                        : .primary
                                )
                                .lineLimit(1)
                        }
                        .frame(width: 72)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Browse \(category.name), \(category.productCount) items")
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
        }
    }

    @ViewBuilder
    private var productContent: some View {
        if feature.isLoading && feature.selectedCategory != nil {
            ProductGridSkeleton(itemCount: 4)
                .padding(.top, AppSpacing.md)
        } else if feature.products.isEmpty && feature.selectedCategory != nil {
            ContentUnavailableView("No products found", systemImage: "magnifyingglass", description: Text("Try selecting a different category"))
                .padding(.top, AppSpacing.xl)
        } else if feature.selectedCategory == nil {
            ContentUnavailableView("Select a category", systemImage: "square.grid.2x2", description: Text("Choose a category above to browse products"))
                .padding(.top, AppSpacing.xl)
        } else {
            ProductGridView(products: feature.products, onProductTapped: onProductTapped)
                .padding(.top, AppSpacing.md)
                .padding(.bottom, AppSpacing.xl)
        }
    }
}
