import SwiftUI

struct PaymentView: View {
    @Binding var methods: [PaymentMethod]
    @Binding var selected: PaymentMethod?
    let onNext: () -> Void
    let onBack: () -> Void
    @State private var showingAddCard = false

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

                    Button {
                        showingAddCard = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                            Text("Add New Card")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(AppSpacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadius)
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [6]))
                                .foregroundStyle(.blue.opacity(0.5))
                        )
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.blue)
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
        .sheet(isPresented: $showingAddCard) {
            NavigationStack {
                CheckoutAddCardFormView(methods: $methods, selected: $selected)
            }
        }
    }
}

struct CheckoutAddCardFormView: View {
    @Binding var methods: [PaymentMethod]
    @Binding var selected: PaymentMethod?
    @Environment(\.dismiss) private var dismiss

    @State private var cardType: PaymentType = .visa
    @State private var cardNumber = ""
    @State private var expiryDate = ""
    @State private var cvv = ""
    @State private var cardholderName = ""

    var body: some View {
        Form {
            Section("Card Type") {
                Picker("Type", selection: $cardType) {
                    Text("Visa").tag(PaymentType.visa)
                    Text("Mastercard").tag(PaymentType.mastercard)
                    Text("Amex").tag(PaymentType.amex)
                }
                .pickerStyle(.segmented)
            }
            Section("Card Details") {
                TextField("Cardholder Name", text: $cardholderName)
                    .textContentType(.name)
                TextField("Card Number", text: $cardNumber)
                    .textContentType(.creditCardNumber)
                    .keyboardType(.numberPad)
                HStack {
                    TextField("MM/YY", text: $expiryDate)
                        .keyboardType(.numberPad)
                    Divider()
                    TextField("CVV", text: $cvv)
                        .keyboardType(.numberPad)
                        .frame(maxWidth: 80)
                }
            }
        }
        .navigationTitle("Add Card")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { save() }
                    .disabled(cardholderName.isEmpty || cardNumber.count < 4 || expiryDate.isEmpty || cvv.isEmpty)
            }
        }
    }

    private func save() {
        let lastFour = String(cardNumber.suffix(4))
        let method = PaymentMethod(
            id: UUID().uuidString,
            type: cardType,
            lastFourDigits: lastFour,
            expiryDate: expiryDate,
            cardholderName: cardholderName,
            isDefault: false
        )
        methods.append(method)
        selected = method
        dismiss()
    }
}
