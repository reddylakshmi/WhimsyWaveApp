import SwiftUI

struct CheckoutView: View {
    @Bindable var feature: CheckoutFeature
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                stepIndicator
                Divider()
                stepContent
            }
            .navigationTitle("checkout.title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("nav.cancel") { dismiss() }
                }
            }
            .task { await feature.loadUserData() }
            .errorAlert($feature.error)
            .sheet(item: $feature.placedOrder) { order in
                OrderConfirmationView(order: order) { dismiss() }
            }
        }
    }

    private var stepIndicator: some View {
        HStack {
            ForEach(CheckoutStepType.allCases, id: \.self) { step in
                VStack(spacing: AppSpacing.xs) {
                    Circle()
                        .fill(step.rawValue <= feature.currentStep.rawValue ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: 28, height: 28)
                        .overlay {
                            Text("\(step.rawValue + 1)")
                                .font(.caption2.bold())
                                .foregroundStyle(.white)
                        }
                    Text(step.title)
                        .font(.caption2)
                        .foregroundStyle(step == feature.currentStep ? .primary : .secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                if step != CheckoutStepType.allCases.last {
                    Rectangle()
                        .fill(step.rawValue < feature.currentStep.rawValue ? Color.blue : Color.gray.opacity(0.3))
                        .frame(height: 2)
                }
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("accessibility.checkoutStep \(feature.currentStep.rawValue + 1) \(CheckoutStepType.allCases.count) \(feature.currentStep.title)")
    }

    @ViewBuilder
    private var stepContent: some View {
        switch feature.currentStep {
        case .shipping:
            ShippingAddressView(addresses: $feature.addresses, selected: $feature.selectedAddress, onNext: { feature.nextStep() })
        case .delivery:
            DeliveryOptionsView(selected: $feature.selectedDelivery, onNext: { feature.nextStep() }, onBack: { feature.previousStep() })
        case .payment:
            PaymentView(methods: $feature.paymentMethods, selected: $feature.selectedPayment, onNext: { feature.nextStep() }, onBack: { feature.previousStep() })
        case .review:
            OrderReviewView(feature: feature)
        }
    }
}
