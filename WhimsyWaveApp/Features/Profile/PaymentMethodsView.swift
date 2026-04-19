import SwiftUI

struct PaymentMethodsView: View {
    @Bindable var feature: ProfileFeature
    @State private var showingAddForm = false

    var body: some View {
        Group {
            if let methods = feature.user?.paymentMethods, !methods.isEmpty {
                List {
                    ForEach(methods) { method in
                        paymentRow(method)
                    }
                    .onDelete { indexSet in
                        guard let methods = feature.user?.paymentMethods else { return }
                        for index in indexSet {
                            let method = methods[index]
                            Task { await feature.deletePaymentMethod(method.id) }
                        }
                    }
                }
            } else {
                ContentUnavailableView {
                    Label("No Payment Methods", systemImage: "creditcard.trianglebadge.exclamationmark")
                } description: {
                    Text("Add a credit or debit card to get started.")
                } actions: {
                    Button("Add Card") { showingAddForm = true }
                        .buttonStyle(.borderedProminent)
                }
            }
        }
        .navigationTitle("Payment Methods")
        .toolbar {
            if feature.user?.paymentMethods.isEmpty == false {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingAddForm = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddForm) {
            NavigationStack {
                AddCardFormView(feature: feature)
            }
        }
    }

    private func paymentRow(_ method: PaymentMethod) -> some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: method.type.iconName)
                .font(.title2)
                .frame(width: 40)
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(method.displayName)
                        .font(.headline)
                    if method.isDefault {
                        Text("Default")
                            .font(.caption2.bold())
                            .padding(.horizontal, AppSpacing.sm)
                            .padding(.vertical, 2)
                            .background(Capsule().fill(Color.accentColor.opacity(0.15)))
                            .foregroundStyle(Color.accentColor)
                    }
                }
                if !method.expiryDate.isEmpty {
                    Text("Expires \(method.expiryDate)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Text(method.cardholderName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, AppSpacing.xs)
    }
}

struct AddCardFormView: View {
    @Bindable var feature: ProfileFeature
    @Environment(\.dismiss) private var dismiss

    @State private var cardType: PaymentType = .visa
    @State private var cardNumber = ""
    @State private var expiryDate = ""
    @State private var cvv = ""
    @State private var cardholderName = ""
    @State private var isDefault = false

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

            Section {
                Toggle("Set as default payment method", isOn: $isDefault)
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
        .onAppear {
            if let user = feature.user {
                cardholderName = user.fullName
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
            isDefault: isDefault
        )
        Task {
            await feature.addPaymentMethod(method)
            dismiss()
        }
    }
}
