import Foundation
import Observation

@Observable @MainActor
final class ProductDetailFeature {
    var product: Product?
    var reviews: [Review] = []
    var selectedVariant: ProductVariant?
    var quantity = 1
    var isInWishlist = false
    var isLoading = false
    var isAddingToCart = false
    var addedToCart = false
    var error: String?

    private let productRepository: IProductRepository
    private let cartRepository: ICartRepository
    private let wishlistRepository: IWishlistRepository
    private let analytics: AnalyticsClient

    init(
        product: Product? = nil,
        productRepository: IProductRepository = MockServiceProvider.productRepository,
        cartRepository: ICartRepository = MockServiceProvider.cartRepository,
        wishlistRepository: IWishlistRepository = MockServiceProvider.wishlistRepository,
        analytics: AnalyticsClient = MockServiceProvider.analyticsClient
    ) {
        self.product = product
        self.productRepository = productRepository
        self.cartRepository = cartRepository
        self.wishlistRepository = wishlistRepository
        self.analytics = analytics
    }

    func checkWishlistStatus() async {
        guard let product else { return }
        isInWishlist = await wishlistRepository.isInWishlist(productId: product.id)
    }

    func loadProduct(id: String) async {
        isLoading = true
        do {
            product = try await productRepository.fetchProduct(id: id)
            if let product {
                analytics.track(.productViewed(id: product.id, name: product.name, price: product.effectivePrice))
                isInWishlist = await wishlistRepository.isInWishlist(productId: product.id)
            }
        } catch {
            self.error = (error as? APIError)?.userFacingMessage ?? error.localizedDescription
        }
        isLoading = false
    }

    func addToCart() async {
        guard let product else { return }
        isAddingToCart = true
        do {
            _ = try await cartRepository.addItem(product, variant: selectedVariant, quantity: quantity)
            analytics.track(.addedToCart(productId: product.id, quantity: quantity))
            addedToCart = true
            try await Task.sleep(for: .seconds(AppConstants.Animation.toastDisplayDuration))
            addedToCart = false
        } catch {
            self.error = "Failed to add to cart"
        }
        isAddingToCart = false
    }

    func toggleWishlist() async {
        guard let product else { return }
        let wasInWishlist = isInWishlist
        isInWishlist.toggle()
        do {
            if wasInWishlist {
                _ = try await wishlistRepository.removeFromWishlist(productId: product.id)
                analytics.track(.wishlistItemRemoved(productId: product.id))
            } else {
                _ = try await wishlistRepository.addToWishlist(product)
                analytics.track(.wishlistItemAdded(productId: product.id))
            }
        } catch {
            isInWishlist = wasInWishlist
            self.error = "Failed to update wishlist"
        }
    }

    func incrementQuantity() {
        if quantity < AppConstants.Cart.maxQuantityPerItem { quantity += 1 }
    }

    func decrementQuantity() {
        if quantity > 1 { quantity -= 1 }
    }
}
