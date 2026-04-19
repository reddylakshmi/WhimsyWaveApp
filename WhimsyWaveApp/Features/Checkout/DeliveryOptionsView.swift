import SwiftUI

struct DeliveryOptionsView: View {
    @Binding var selected: DeliveryOption
    let onNext: () -> Void
    let onBack: () -> Void

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: AppSpacing.md) {
                    ForEach(DeliveryOption.allOptions) { option in
                        Button {
                            selected = option
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                                    HStack {
                                        Text(option.name).font(.headline)
                                        if option.isExpress {
                                            Text("EXPRESS")
                                                .font(.caption2.bold())
                                                .padding(.horizontal, AppSpacing.sm)
                                                .background(Capsule().fill(.orange))
                                                .foregroundStyle(.white)
                                        }
                                    }
                                    Text(option.estimatedDays)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(option.price == 0 ? "FREE" : formatPrice(option.price))
                                    .font(.subheadline.bold())
                                    .foregroundStyle(option.price == 0 ? .green : .primary)
                                Image(systemName: selected.id == option.id ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(selected.id == option.id ? .blue : .gray)
                            }
                            .padding(AppSpacing.md)
                            .background(
                                RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadius)
                                    .stroke(selected.id == option.id ? .blue : .gray.opacity(0.3), lineWidth: selected.id == option.id ? 2 : 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(AppSpacing.md)
            }
            Spacer()
            HStack(spacing: AppSpacing.md) {
                Button(action: onBack) {
                    Text("Back")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppSpacing.md)
                        .background(RoundedRectangle(cornerRadius: AppConstants.Layout.buttonCornerRadius).stroke(.blue))
                }
                Button(action: onNext) {
                    Text("Continue to Payment")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppSpacing.md)
                        .background(RoundedRectangle(cornerRadius: AppConstants.Layout.buttonCornerRadius).fill(.blue))
                }
            }
            .padding(AppSpacing.md)
        }
    }

    private func formatPrice(_ value: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: value as NSDecimalNumber) ?? "$0.00"
    }
}
