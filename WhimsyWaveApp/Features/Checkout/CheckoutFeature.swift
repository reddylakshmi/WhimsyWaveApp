import Foundation
import Observation

enum CheckoutStepType: Int, CaseIterable, Sendable {
    case shipping = 0
    case delivery = 1
    case payment = 2
    case review = 3

    var title: String {
        switch self {
        case .shipping: return "Shipping"
        case .delivery: return "Delivery"
        case .payment: return "Payment"
        case .review: return "Review"
        }
    }
}

struct DeliveryOption: Identifiable, Equatable, Sendable {
    let id: String
    let name: String
    let estimatedDays: String
    let price: Decimal
    let isExpress: Bool

    static let standard = DeliveryOption(id: "DEL-001", name: "Standard Shipping", estimatedDays: "5-7 business days", price: 0, isExpress: false)
    static let expedited = DeliveryOption(id: "DEL-002", name: "Expedited Shipping", estimatedDays: "2-3 business days", price: AppConstants.Shipping.expeditedCost, isExpress: false)
    static let express = DeliveryOption(id: "DEL-003", name: "Express Shipping", estimatedDays: "1 business day", price: AppConstants.Shipping.expressCost, isExpress: true)

    static let allOptions: [DeliveryOption] = [.standard, .expedited, .express]
}

@Observable @MainActor
final class CheckoutFeature {
    var currentStep: CheckoutStepType = .shipping
    var cart: Cart
    var selectedAddress: Address?
    var addresses: [Address] = []
    var selectedDelivery: DeliveryOption = .standard
    var selectedPayment: PaymentMethod?
    var paymentMethods: [PaymentMethod] = []
    var isPlacingOrder = false
    var placedOrder: Order?
    var error: String?

    private let checkoutUseCase: CheckoutUseCase
    private let userRepository: IUserRepository
    private let analytics: AnalyticsClient

    init(
        cart: Cart,
        orderRepository: IOrderRepository = MockServiceProvider.orderRepository,
        userRepository: IUserRepository = MockServiceProvider.userRepository,
        cartRepository: ICartRepository = MockServiceProvider.cartRepository,
        analytics: AnalyticsClient = MockServiceProvider.analyticsClient
    ) {
        self.cart = cart
        self.checkoutUseCase = CheckoutUseCase(orderRepository: orderRepository, cartRepository: cartRepository)
        self.userRepository = userRepository
        self.analytics = analytics
    }

    var subtotal: Decimal { cart.totalPrice }
    var shippingCost: Decimal { selectedDelivery.price }
    var tax: Decimal { subtotal * AppConstants.Tax.rate }
    var total: Decimal { subtotal + shippingCost + tax }

    func loadUserData() async {
        do {
            let user = try await userRepository.fetchProfile(userId: "current")
            addresses = user.addresses
            selectedAddress = user.defaultAddress
            paymentMethods = user.paymentMethods
            selectedPayment = paymentMethods.first(where: { $0.isDefault }) ?? paymentMethods.first
        } catch {
            self.error = "Failed to load checkout data"
        }
        analytics.track(.checkoutStarted(cartValue: cart.totalPrice, itemCount: cart.itemCount))
    }

    func nextStep() {
        if let next = CheckoutStepType(rawValue: currentStep.rawValue + 1) {
            HapticFeedback.light()
            analytics.track(.checkoutStepCompleted(step: CheckoutStep(rawValue: currentStep.title.lowercased()) ?? .shippingAddress))
            currentStep = next
        }
    }

    func previousStep() {
        if let prev = CheckoutStepType(rawValue: currentStep.rawValue - 1) {
            currentStep = prev
        }
    }

    func placeOrder() async {
        guard let address = selectedAddress, let payment = selectedPayment else {
            error = "Please complete all checkout steps"
            return
        }
        isPlacingOrder = true
        do {
            let order = try await checkoutUseCase.execute(cart: cart, address: address, payment: payment)
            placedOrder = order
            HapticFeedback.success()
            analytics.track(.orderCompleted(orderId: order.id, total: order.totalAmount))
        } catch {
            HapticFeedback.error()
            self.error = (error as? APIError)?.userFacingMessage ?? error.localizedDescription
        }
        isPlacingOrder = false
    }
}
