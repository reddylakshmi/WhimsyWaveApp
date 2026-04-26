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
                                        Text("payment.expires \(method.expiryDate)")
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
                            Text("payment.addNewCard")
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
                    Text("nav.back")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppSpacing.md)
                        .background(RoundedRectangle(cornerRadius: AppConstants.Layout.buttonCornerRadius).stroke(.blue))
                }
                Button(action: onNext) {
                    Text("checkout.reviewOrder")
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
    @State private var hasAttemptedSave = false

    private var isCardNumberValid: Bool { cardNumber.filter(\.isNumber).count >= 13 }
    private var isCVVValid: Bool { cvv.count >= 3 && cvv.allSatisfy(\.isNumber) }
    private var isExpiryValid: Bool {
        let parts = expiryDate.split(separator: "/")
        guard parts.count == 2, let month = Int(parts[0]), let _ = Int(parts[1]) else { return false }
        return month >= 1 && month <= 12
    }
    private var isFormValid: Bool { !cardholderName.isEmpty && isCardNumberValid && isExpiryValid && isCVVValid }

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
                if hasAttemptedSave && cardholderName.isEmpty {
                    Text("validation.cardholderRequired")
                        .font(.caption).foregroundStyle(.red)
                }
                TextField(text: $cardNumber) { Text("form.cardNumber") }
                    .textContentType(.creditCardNumber)
                    .keyboardType(.numberPad)
                if hasAttemptedSave && !isCardNumberValid {
                    Text("validation.cardNumberInvalid")
                        .font(.caption).foregroundStyle(.red)
                }
                HStack {
                    TextField("MM/YY", text: $expiryDate)
                        .keyboardType(.numbersAndPunctuation)
                    Divider()
                    TextField("CVV", text: $cvv)
                        .keyboardType(.numberPad)
                        .frame(maxWidth: 80)
                }
                if hasAttemptedSave && (!isExpiryValid || !isCVVValid) {
                    Text("validation.expiryOrCvvInvalid")
                        .font(.caption).foregroundStyle(.red)
                }
            }
        }
        .navigationTitle("payment.addCard")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("nav.cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("action.save") {
                    hasAttemptedSave = true
                    if isFormValid { save() }
                }
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
