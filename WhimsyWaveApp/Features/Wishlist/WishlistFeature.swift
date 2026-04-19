import Foundation
import Observation

@Observable @MainActor
final class WishlistFeature {
    var items: [WishlistItem] = []
    var isLoading = false
    var error: String?

    private let wishlistRepository: IWishlistRepository
    private let cartRepository: ICartRepository
    private let analytics: AnalyticsClient

    init(
        wishlistRepository: IWishlistRepository = MockServiceProvider.wishlistRepository,
        cartRepository: ICartRepository = MockServiceProvider.cartRepository,
        analytics: AnalyticsClient = MockServiceProvider.analyticsClient
    ) {
        self.wishlistRepository = wishlistRepository
        self.cartRepository = cartRepository
        self.analytics = analytics
    }

    func loadWishlist() async {
        isLoading = true
        do {
            items = try await wishlistRepository.getWishlist()
        } catch {
            self.error = (error as? APIError)?.userFacingMessage ?? error.localizedDescription
        }
        isLoading = false
    }

    func removeItem(productId: String) async {
        do {
            items = try await wishlistRepository.removeFromWishlist(productId: productId)
            analytics.track(.wishlistItemRemoved(productId: productId))
        } catch {
            self.error = "Failed to remove item"
        }
    }

    func moveToCart(_ item: WishlistItem) async {
        do {
            _ = try await cartRepository.addItem(item.product, variant: nil, quantity: 1)
            items = try await wishlistRepository.removeFromWishlist(productId: item.product.id)
            analytics.track(.addedToCart(productId: item.product.id, quantity: 1))
        } catch {
            self.error = "Failed to move item to cart"
        }
    }
}
