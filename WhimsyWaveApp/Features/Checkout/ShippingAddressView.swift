import SwiftUI

struct ShippingAddressView: View {
    let addresses: [Address]
    @Binding var selected: Address?
    let onNext: () -> Void

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: AppSpacing.md) {
                    ForEach(addresses) { address in
                        Button {
                            selected = address
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                                    HStack {
                                        Text(address.label).font(.headline)
                                        if address.isDefault {
                                            Text("Default")
                                                .font(.caption2)
                                                .padding(.horizontal, AppSpacing.sm)
                                                .background(Capsule().fill(.blue.opacity(0.1)))
                                                .foregroundStyle(.blue)
                                        }
                                    }
                                    Text(address.fullName).font(.subheadline)
                                    Text(address.formattedAddress)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Image(systemName: selected?.id == address.id ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(selected?.id == address.id ? .blue : .gray)
                                    .font(.title3)
                            }
                            .padding(AppSpacing.md)
                            .background(
                                RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadius)
                                    .stroke(selected?.id == address.id ? .blue : .gray.opacity(0.3), lineWidth: selected?.id == address.id ? 2 : 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(AppSpacing.md)
            }
            Spacer()
            Button(action: onNext) {
                Text("Continue to Delivery")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.md)
                    .background(RoundedRectangle(cornerRadius: AppConstants.Layout.buttonCornerRadius).fill(.blue))
            }
            .disabled(selected == nil)
            .padding(AppSpacing.md)
        }
    }
}
