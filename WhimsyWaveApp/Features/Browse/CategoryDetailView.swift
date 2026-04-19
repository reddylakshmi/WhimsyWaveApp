import SwiftUI

struct CategoryDetailView: View {
    @Bindable var feature: BrowseFeature
    let category: Category
    var onProductTapped: (Product) -> Void = { _ in }

    var body: some View {
        ScrollView {
            if feature.isLoading {
                ProgressView()
                    .padding(.top, AppSpacing.xxl)
            } else {
                ProductGridView(products: feature.products, onProductTapped: onProductTapped)
            }
        }
        .navigationTitle(category.name)
        .task { await feature.selectCategory(category) }
    }
}
