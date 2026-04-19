import Foundation

struct AddToCartUseCase: Sendable {
    let cartRepository: ICartRepository

    func execute(product: Product, variant: ProductVariant? = nil, quantity: Int = 1) async throws -> Cart {
        try await cartRepository.addItem(product, variant: variant, quantity: quantity)
    }
}
