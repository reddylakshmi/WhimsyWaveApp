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
                                            Text("delivery.express")
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
                                Text(option.price == 0 ? String(localized: "price.free", locale: RegionManager.shared.currentRegion.locale) : PriceFormatter.format(option.price))
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
                    Text("nav.back")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppSpacing.md)
                        .background(RoundedRectangle(cornerRadius: AppConstants.Layout.buttonCornerRadius).stroke(.blue))
                }
                Button(action: onNext) {
                    Text("checkout.continueToPayment")
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

}
