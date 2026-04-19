import Foundation
import Observation

@Observable @MainActor
final class CartFeature {
    var cart: Cart = .empty
    var isLoading = false
    var error: String?

    private let cartRepository: ICartRepository
    private let analytics: AnalyticsClient

    init(
        cartRepository: ICartRepository = MockServiceProvider.cartRepository,
        analytics: AnalyticsClient = MockServiceProvider.analyticsClient
    ) {
        self.cartRepository = cartRepository
        self.analytics = analytics
    }

    func loadCart() async {
        isLoading = true
        do {
            cart = try await cartRepository.getCart()
            analytics.track(.cartViewed(itemCount: cart.itemCount, totalValue: cart.totalPrice))
        } catch {
            self.error = (error as? APIError)?.userFacingMessage ?? error.localizedDescription
        }
        isLoading = false
    }

    func removeItem(_ item: CartItem) async {
        do {
            cart = try await cartRepository.removeItem(cartItemId: item.id)
            analytics.track(.removedFromCart(productId: item.product.id))
        } catch {
            self.error = "Failed to remove item"
        }
    }

    func updateQuantity(_ item: CartItem, quantity: Int) async {
        do {
            cart = try await cartRepository.updateQuantity(cartItemId: item.id, quantity: quantity)
        } catch {
            self.error = "Failed to update quantity"
        }
    }

    func incrementQuantity(_ item: CartItem) async {
        await updateQuantity(item, quantity: item.quantity + 1)
    }

    func decrementQuantity(_ item: CartItem) async {
        if item.quantity > 1 {
            await updateQuantity(item, quantity: item.quantity - 1)
        } else {
            await removeItem(item)
        }
    }

    func clearCart() async {
        do {
            try await cartRepository.clearCart()
            cart = .empty
        } catch {
            self.error = "Failed to clear cart"
        }
    }
}
