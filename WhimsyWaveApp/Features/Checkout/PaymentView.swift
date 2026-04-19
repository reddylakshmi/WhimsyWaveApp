import SwiftUI

struct PaymentView: View {
    let methods: [PaymentMethod]
    @Binding var selected: PaymentMethod?
    let onNext: () -> Void
    let onBack: () -> Void

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: AppSpacing.md) {
                    ForEach(methods) { method in
                        Button {
                            selected = method
                        } label: {
                            HStack(spacing: AppSpacing.md) {
                                Image(systemName: method.type.iconName)
                                    .font(.title2)
                                    .frame(width: AppConstants.Layout.minTapTarget)
                                VStack(alignment: .leading) {
                                    Text(method.displayName).font(.headline)
                                    if !method.expiryDate.isEmpty {
                                        Text("Expires \(method.expiryDate)")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                Spacer()
                                Image(systemName: selected?.id == method.id ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(selected?.id == method.id ? .blue : .gray)
                            }
                            .padding(AppSpacing.md)
                            .background(
                                RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadius)
                                    .stroke(selected?.id == method.id ? .blue : .gray.opacity(0.3), lineWidth: selected?.id == method.id ? 2 : 1)
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
                    Text("Review Order")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppSpacing.md)
                        .background(RoundedRectangle(cornerRadius: AppConstants.Layout.buttonCornerRadius).fill(.blue))
                }
                .disabled(selected == nil)
            }
            .padding(AppSpacing.md)
        }
    }
}
