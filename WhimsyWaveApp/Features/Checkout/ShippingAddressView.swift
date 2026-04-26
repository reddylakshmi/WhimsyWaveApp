import SwiftUI

struct ShippingAddressView: View {
    @Binding var addresses: [Address]
    @Binding var selected: Address?
    let onNext: () -> Void
    @State private var showingAddForm = false
    @State private var editingAddress: Address?

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
                                            Text("badge.default")
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
                                VStack(spacing: AppSpacing.sm) {
                                    Image(systemName: selected?.id == address.id ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(selected?.id == address.id ? .blue : .gray)
                                        .font(.title3)
                                    Button {
                                        editingAddress = address
                                    } label: {
                                        Text("action.edit")
                                            .font(.caption)
                                            .foregroundStyle(.blue)
                                    }
                                }
                            }
                            .padding(AppSpacing.md)
                            .background(
                                RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadius)
                                    .stroke(selected?.id == address.id ? .blue : .gray.opacity(0.3), lineWidth: selected?.id == address.id ? 2 : 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    Button {
                        showingAddForm = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                            Text("address.addNew")
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
            Button(action: onNext) {
                Text("checkout.continueToDelivery")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.md)
                    .background(RoundedRectangle(cornerRadius: AppConstants.Layout.buttonCornerRadius).fill(.blue))
            }
            .disabled(selected == nil)
            .padding(AppSpacing.md)
        }
        .sheet(isPresented: $showingAddForm) {
            NavigationStack {
                CheckoutAddressFormView(addresses: $addresses, selected: $selected, address: nil)
            }
        }
        .sheet(item: $editingAddress) { address in
            NavigationStack {
                CheckoutAddressFormView(addresses: $addresses, selected: $selected, address: address)
            }
        }
    }
}

struct CheckoutAddressFormView: View {
    @Binding var addresses: [Address]
    @Binding var selected: Address?
    let address: Address?
    @Environment(\.dismiss) private var dismiss

    @State private var label = "Home"
    @State private var fullName = ""
    @State private var street = ""
    @State private var apartment = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zipCode = ""
    @State private var phone = ""

    @State private var hasAttemptedSave = false

    private var isEditing: Bool { address != nil }
    private var isZipValid: Bool { zipCode.isEmpty || zipCode.allSatisfy(\.isNumber) && zipCode.count <= 5 }
    private var isPhoneValid: Bool { phone.isEmpty || phone.filter(\.isNumber).count >= 10 }
    private var isFormValid: Bool {
        !fullName.isEmpty && !street.isEmpty && !city.isEmpty && !state.isEmpty
        && zipCode.count == 5 && zipCode.allSatisfy(\.isNumber)
        && phone.filter(\.isNumber).count >= 10
    }

    var body: some View {
        Form {
            Section("form.addressLabel") {
                Picker("form.label", selection: $label) {
                    Text("form.home").tag("Home")
                    Text("form.office").tag("Office")
                    Text("form.other").tag("Other")
                }
                .pickerStyle(.segmented)
            }
            Section("form.contact") {
                TextField(text: $fullName) { Text("form.fullName") }
                    .textContentType(.name)
                if hasAttemptedSave && fullName.isEmpty {
                    Text("validation.fullNameRequired")
                        .font(.caption).foregroundStyle(.red)
                }
                TextField(text: $phone) { Text("form.phone") }
                    .textContentType(.telephoneNumber)
                    .keyboardType(.phonePad)
                if hasAttemptedSave && !isPhoneValid {
                    Text("validation.phoneInvalid")
                        .font(.caption).foregroundStyle(.red)
                }
            }
            Section("form.address") {
                TextField(text: $street) { Text("form.streetAddress") }
                    .textContentType(.streetAddressLine1)
                TextField(text: $apartment) { Text("form.apartment") }
                    .textContentType(.streetAddressLine2)
                TextField(text: $city) { Text("form.city") }
                    .textContentType(.addressCity)
                TextField(text: $state) { Text("form.state") }
                    .textContentType(.addressState)
                TextField(text: $zipCode) { Text("form.zipCode") }
                    .textContentType(.postalCode)
                    .keyboardType(.numberPad)
                if hasAttemptedSave && (zipCode.count != 5 || !zipCode.allSatisfy(\.isNumber)) {
                    Text("validation.zipInvalid")
                        .font(.caption).foregroundStyle(.red)
                }
            }
        }
        .navigationTitle(isEditing ? "address.edit" : "address.add")
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
        .onAppear {
            if let address {
                label = address.label
                fullName = address.fullName
                street = address.street
                apartment = address.apartment ?? ""
                city = address.city
                state = address.state
                zipCode = address.zipCode
                phone = address.phone
            }
        }
    }

    private func save() {
        let newAddress = Address(
            id: address?.id ?? UUID().uuidString,
            label: label,
            fullName: fullName,
            street: street,
            apartment: apartment.isEmpty ? nil : apartment,
            city: city,
            state: state,
            zipCode: zipCode,
            phone: phone,
            isDefault: false
        )
        if isEditing {
            if let index = addresses.firstIndex(where: { $0.id == newAddress.id }) {
                addresses[index] = newAddress
            }
        } else {
            addresses.append(newAddress)
        }
        selected = newAddress
        dismiss()
    }
}
