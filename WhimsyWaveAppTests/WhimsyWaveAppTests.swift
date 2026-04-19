import Testing
import Foundation
@testable import WhimsyWaveApp

// MARK: - Domain Model Tests

struct CartTests {
    @Test func emptyCartHasZeroItems() {
        let cart = Cart.empty
        #expect(cart.isEmpty)
        #expect(cart.itemCount == 0)
        #expect(cart.totalPrice == 0)
    }

    @Test func cartTotalPriceCalculatesCorrectly() {
        let cart = Cart.mockCart
        #expect(!cart.isEmpty)
        #expect(cart.itemCount > 0)
        #expect(cart.totalPrice > 0)
    }

    @Test func cartItemCountSumsQuantities() {
        let cart = Cart(items: [
            CartItem(id: "CI-A", product: .mockSofa, quantity: 2),
            CartItem(id: "CI-B", product: .mockFloorLamp, quantity: 3)
        ])
        #expect(cart.itemCount == 5)
    }

    @Test func displayTotalFormatsAsCurrency() {
        let cart = Cart.mockSingleItem
        let display = cart.displayTotal
        #expect(display.contains("$"))
    }
}

struct ProductTests {
    @Test func productOnSaleDetection() {
        let product = Product.mockSofa
        #expect(product.isOnSale)
        #expect(product.discountPercentage != nil)
    }

    @Test func productNotOnSaleWhenNoSalePrice() {
        let product = Product.mockFloorLamp
        if product.salePrice == nil {
            #expect(!product.isOnSale)
        }
    }

    @Test func effectivePriceReturnsSalePriceWhenAvailable() {
        let product = Product.mockSofa
        if product.isOnSale, let salePrice = product.salePrice {
            #expect(product.effectivePrice == salePrice)
        }
    }

    @Test func displayPriceFormatsCorrectly() {
        let product = Product.mockSofa
        #expect(product.displayPrice.contains("$"))
    }
}

struct CartItemTests {
    @Test func lineTotalCalculatesCorrectly() {
        let item = CartItem(id: "CI-T", product: .mockSofa, quantity: 3)
        let expectedTotal = item.product.effectivePrice * 3
        #expect(item.lineTotal == expectedTotal)
    }
}

struct OrderStatusTests {
    @Test func orderStatusProgressValues() {
        #expect(OrderStatus.placed.progressValue < OrderStatus.shipped.progressValue)
        #expect(OrderStatus.shipped.progressValue < OrderStatus.delivered.progressValue)
    }

    @Test func allStatusesHaveDisplayNames() {
        for status in [OrderStatus.placed, .confirmed, .processing, .shipped, .outForDelivery, .delivered, .cancelled, .returned] {
            #expect(!status.displayName.isEmpty)
        }
    }
}

struct AddressTests {
    @Test func formattedAddressIncludesAllParts() {
        let address = Address.mockHome
        let formatted = address.formattedAddress
        #expect(formatted.contains(address.city))
        #expect(formatted.contains(address.state))
    }
}

struct FilterTests {
    @Test func defaultFilterHasNoActiveFilters() {
        let filter = ProductFilter()
        #expect(!filter.hasActiveFilters)
    }

    @Test func filterWithInStockOnlyIsActive() {
        var filter = ProductFilter()
        filter.inStockOnly = true
        #expect(filter.hasActiveFilters)
    }

    @Test func sortOptionsHaveDisplayNames() {
        for option in SortOption.allCases {
            #expect(!option.rawValue.isEmpty)
        }
    }
}

// MARK: - Feature Tests

@Suite(.serialized)
struct HomeFeatureTests {
    @Test @MainActor func initialStateIsEmpty() {
        let feature = HomeFeature()
        #expect(feature.sections.isEmpty)
        #expect(feature.banners.isEmpty)
        #expect(!feature.isLoading)
        #expect(feature.error == nil)
    }

    @Test @MainActor func onAppearLoadsSections() async {
        let feature = HomeFeature()
        await feature.onAppear()
        #expect(!feature.sections.isEmpty)
        #expect(!feature.isLoading)
        #expect(feature.error == nil)
    }

    @Test @MainActor func onAppearDoesNotReloadIfSectionsExist() async {
        let feature = HomeFeature()
        await feature.onAppear()
        let sectionCount = feature.sections.count
        await feature.onAppear()
        #expect(feature.sections.count == sectionCount)
    }

    @Test @MainActor func refreshReloadsContent() async {
        let feature = HomeFeature()
        await feature.onAppear()
        let originalCount = feature.sections.count
        await feature.refresh()
        #expect(feature.sections.count == originalCount)
    }
}

@Suite(.serialized)
struct CartFeatureTests {
    @Test @MainActor func initialCartIsEmpty() {
        let feature = CartFeature()
        #expect(feature.cart.isEmpty)
        #expect(!feature.isLoading)
    }

    @Test @MainActor func loadCartFetchesFromRepository() async {
        let feature = CartFeature()
        await feature.loadCart()
        #expect(!feature.isLoading)
        #expect(feature.error == nil)
    }

    @Test @MainActor func clearCartEmptiesItems() async {
        let feature = CartFeature()
        await feature.clearCart()
        #expect(feature.cart.isEmpty)
    }
}

@Suite(.serialized)
struct CheckoutFeatureTests {
    @Test @MainActor func initialStepIsShipping() {
        let feature = CheckoutFeature(cart: .mockCart)
        #expect(feature.currentStep == .shipping)
    }

    @Test @MainActor func nextStepAdvancesCorrectly() {
        let feature = CheckoutFeature(cart: .mockCart)
        #expect(feature.currentStep == .shipping)
        feature.nextStep()
        #expect(feature.currentStep == .delivery)
        feature.nextStep()
        #expect(feature.currentStep == .payment)
        feature.nextStep()
        #expect(feature.currentStep == .review)
    }

    @Test @MainActor func previousStepGoesBack() {
        let feature = CheckoutFeature(cart: .mockCart)
        feature.nextStep()
        feature.nextStep()
        #expect(feature.currentStep == .payment)
        feature.previousStep()
        #expect(feature.currentStep == .delivery)
    }

    @Test @MainActor func subtotalMatchesCartTotal() {
        let cart = Cart.mockCart
        let feature = CheckoutFeature(cart: cart)
        #expect(feature.subtotal == cart.totalPrice)
    }

    @Test @MainActor func taxCalculatesCorrectly() {
        let feature = CheckoutFeature(cart: .mockCart)
        let expectedTax = feature.subtotal * Decimal(string: "0.0825")!
        #expect(feature.tax == expectedTax)
    }

    @Test @MainActor func totalIncludesSubtotalShippingAndTax() {
        let feature = CheckoutFeature(cart: .mockCart)
        let expectedTotal = feature.subtotal + feature.shippingCost + feature.tax
        #expect(feature.total == expectedTotal)
    }

    @Test @MainActor func standardShippingIsFree() {
        let feature = CheckoutFeature(cart: .mockCart)
        #expect(feature.selectedDelivery == .standard)
        #expect(feature.shippingCost == 0)
    }

    @Test @MainActor func loadUserDataSetsAddressesAndPayment() async {
        let feature = CheckoutFeature(cart: .mockCart)
        await feature.loadUserData()
        #expect(!feature.addresses.isEmpty)
        #expect(feature.selectedAddress != nil)
        #expect(!feature.paymentMethods.isEmpty)
        #expect(feature.selectedPayment != nil)
    }

    @Test @MainActor func placeOrderFailsWithoutAddressAndPayment() async {
        let feature = CheckoutFeature(cart: .mockCart)
        await feature.placeOrder()
        #expect(feature.error != nil)
        #expect(feature.placedOrder == nil)
    }
}

// MARK: - Checkout Step Type Tests

struct CheckoutStepTypeTests {
    @Test func allStepsHaveTitles() {
        for step in CheckoutStepType.allCases {
            #expect(!step.title.isEmpty)
        }
    }

    @Test func stepsAreInCorrectOrder() {
        #expect(CheckoutStepType.shipping.rawValue == 0)
        #expect(CheckoutStepType.delivery.rawValue == 1)
        #expect(CheckoutStepType.payment.rawValue == 2)
        #expect(CheckoutStepType.review.rawValue == 3)
    }
}

// MARK: - Delivery Option Tests

struct DeliveryOptionTests {
    @Test func standardShippingIsFree() {
        #expect(DeliveryOption.standard.price == 0)
        #expect(!DeliveryOption.standard.isExpress)
    }

    @Test func expressShippingIsMarkedExpress() {
        #expect(DeliveryOption.express.isExpress)
        #expect(DeliveryOption.express.price > 0)
    }

    @Test func allOptionsContainsThreeChoices() {
        #expect(DeliveryOption.allOptions.count == 3)
    }
}

// MARK: - API Error Tests

struct APIErrorTests {
    @Test func userFacingMessagesAreNotEmpty() {
        let errors: [APIError] = [
            .networkUnavailable, .timeout, .unauthorized,
            .serverError, .notFound, .unknown("test")
        ]
        for error in errors {
            #expect(!error.userFacingMessage.isEmpty)
        }
    }
}

// MARK: - Feature Flag Tests

struct FeatureFlagTests {
    @Test func allEnabledClientReturnsTrue() {
        let client = FeatureFlagClient.allEnabled
        #expect(client.boolValue(.arViewEnabled))
        #expect(client.boolValue(.voiceSearch))
    }

    @Test func allDisabledClientReturnsFalse() {
        let client = FeatureFlagClient.allDisabled
        #expect(!client.boolValue(.arViewEnabled))
        #expect(!client.boolValue(.voiceSearch))
    }
}
