import Foundation

protocol IWishlistRepository: Sendable {
    func getWishlist() async throws -> [WishlistItem]
    func addToWishlist(_ product: Product) async throws -> [WishlistItem]
    func removeFromWishlist(productId: String) async throws -> [WishlistItem]
    func isInWishlist(productId: String) async -> Bool
}
