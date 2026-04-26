import Foundation
import Observation

enum CheckoutStepType: Int, CaseIterable, Sendable {
    case shipping = 0
    case delivery = 1
    case payment = 2
    case review = 3

    var title: String {
        let locale = RegionManager.shared.currentRegion.locale
        switch self {
        case .shipping: return String(localized: "checkout.shipping", defaultValue: "Shipping", locale: locale)
        case .delivery: return String(localized: "checkout.delivery", defaultValue: "Delivery", locale: locale)
        case .payment: return String(localized: "checkout.payment", defaultValue: "Payment", locale: locale)
        case .review: return String(localized: "checkout.review", defaultValue: "Review", locale: locale)
        }
    }
}

struct DeliveryOption: Identifiable, Equatable, Sendable {
    let id: String
    let name: String
    let estimatedDays: String
    let price: Decimal
    let isExpress: Bool

    static let standard = DeliveryOption(id: "DEL-001", name: String(localized: "checkout.standard", defaultValue: "Standard Shipping", locale: RegionManager.shared.currentRegion.locale), estimatedDays: String(localized: "checkout.days.5to7", defaultValue: "5-7 business days", locale: RegionManager.shared.currentRegion.locale), price: 0, isExpress: false)
    static let expedited = DeliveryOption(id: "DEL-002", name: String(localized: "checkout.expedited", defaultValue: "Expedited Shipping", locale: RegionManager.shared.currentRegion.locale), estimatedDays: String(localized: "checkout.days.2to3", defaultValue: "2-3 business days", locale: RegionManager.shared.currentRegion.locale), price: AppConstants.Shipping.expeditedCost, isExpress: false)
    static let express = DeliveryOption(id: "DEL-003", name: String(localized: "checkout.express", defaultValue: "Express Shipping", locale: RegionManager.shared.currentRegion.locale), estimatedDays: String(localized: "checkout.days.1", defaultValue: "1 business day", locale: RegionManager.shared.currentRegion.locale), price: AppConstants.Shipping.expressCost, isExpress: true)

    static let allOptions: [DeliveryOption] = [.standard, .expedited, .express]

    static func options(for region: Region) -> [DeliveryOption] {
        let multiplier = region.priceMultiplier
        let locale = region.locale
        return [
            DeliveryOption(id: "DEL-001", name: String(localized: "checkout.standard", defaultValue: "Standard Shipping", locale: locale), estimatedDays: String(localized: "checkout.days.5to7", defaultValue: "5-7 business days", locale: locale), price: 0, isExpress: false),
            DeliveryOption(id: "DEL-002", name: String(localized: "checkout.expedited", defaultValue: "Expedited Shipping", locale: locale), estimatedDays: String(localized: "checkout.days.2to3", defaultValue: "2-3 business days", locale: locale), price: (Decimal(string: "14.99")! * multiplier).roundedToTwo, isExpress: false),
            DeliveryOption(id: "DEL-003", name: String(localized: "checkout.express", defaultValue: "Express Shipping", locale: locale), estimatedDays: String(localized: "checkout.days.1", defaultValue: "1 business day", locale: locale), price: (Decimal(string: "29.99")! * multiplier).roundedToTwo, isExpress: true)
        ]
    }
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

    private var region: Region { RegionManager.shared.currentRegion }
    var subtotal: Decimal { cart.totalPrice }
    var shippingCost: Decimal { selectedDelivery.price }
    var tax: Decimal { subtotal * region.taxRate }
    var total: Decimal { subtotal + shippingCost + tax }

    func loadUserData() async {
        do {
            let user = try await userRepository.fetchProfile(userId: "current")
            addresses = user.addresses
            selectedAddress = user.defaultAddress
            paymentMethods = user.paymentMethods
            selectedPayment = paymentMethods.first(where: { $0.isDefault }) ?? paymentMethods.first
        } catch {
            self.error = String(localized: "checkout.loadError", defaultValue: "Failed to load checkout data", locale: region.locale)
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
            error = String(localized: "checkout.incomplete", defaultValue: "Please complete all checkout steps", locale: region.locale)
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
