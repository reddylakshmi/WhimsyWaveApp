import SwiftUI

struct PaymentMethodsView: View {
    @Bindable var feature: AccountFeature
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
                    Label("payment.empty.title", systemImage: "creditcard.trianglebadge.exclamationmark")
                } description: {
                    Text("payment.empty.description")
                } actions: {
                    Button("payment.addCard") { showingAddForm = true }
                        .buttonStyle(.borderedProminent)
                }
            }
        }
        .navigationTitle("account.paymentMethods")
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
                        Text("badge.default")
                            .font(.caption2.bold())
                            .padding(.horizontal, AppSpacing.sm)
                            .padding(.vertical, 2)
                            .background(Capsule().fill(Color.accentColor.opacity(0.15)))
                            .foregroundStyle(Color.accentColor)
                    }
                }
                if !method.expiryDate.isEmpty {
                    Text("payment.expires \(method.expiryDate)")
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
    @Bindable var feature: AccountFeature
    @Environment(\.dismiss) private var dismiss

    @State private var cardType: PaymentType = .visa
    @State private var cardNumber = ""
    @State private var expiryDate = ""
    @State private var cvv = ""
    @State private var cardholderName = ""
    @State private var isDefault = false

    var body: some View {
        Form {
            Section("form.cardType") {
                Picker(selection: $cardType) {
                    Text("Visa").tag(PaymentType.visa)
                    Text("Mastercard").tag(PaymentType.mastercard)
                    Text("Amex").tag(PaymentType.amex)
                } label: {
                    Text("form.type")
                }
                .pickerStyle(.segmented)
            }

            Section("form.cardDetails") {
                TextField(text: $cardholderName) { Text("form.cardholderName") }
                    .textContentType(.name)
                TextField(text: $cardNumber) { Text("form.cardNumber") }
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
                Toggle("form.setDefaultPayment", isOn: $isDefault)
            }
        }
        .navigationTitle("payment.addCard")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("nav.cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("action.save") { save() }
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
