import SwiftUI

struct OrderConfirmationView: View {
    let order: Order
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: AppSpacing.xl) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.green)

            VStack(spacing: AppSpacing.sm) {
                Text("Order Placed!")
                    .font(.title.bold())
                Text("Order #\(order.orderNumber)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: AppSpacing.sm) {
                Text("Your order has been placed successfully.")
                    .multilineTextAlignment(.center)
                if let delivery = order.estimatedDelivery {
                    Text("Estimated delivery: \(delivery.earliest.formatted(.dateTime.month().day())) - \(delivery.latest.formatted(.dateTime.month().day()))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, AppSpacing.xl)

            Text(order.displayTotal)
                .font(.title2.bold())

            Spacer()

            Button(action: onDone) {
                Text("Continue Shopping")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.md)
                    .background(RoundedRectangle(cornerRadius: AppConstants.Layout.buttonCornerRadius).fill(.blue))
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.bottom, AppSpacing.lg)
        }
    }
}
