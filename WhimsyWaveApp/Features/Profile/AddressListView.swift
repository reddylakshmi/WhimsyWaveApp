import SwiftUI

struct AddressListView: View {
    @Bindable var feature: AccountFeature
    @State private var showingAddForm = false
    @State private var editingAddress: Address?

    var body: some View {
        Group {
            if let addresses = feature.user?.addresses, !addresses.isEmpty {
                List {
                    ForEach(addresses) { address in
                        addressRow(address)
                    }
                    .onDelete { indexSet in
                        guard let addresses = feature.user?.addresses else { return }
                        for index in indexSet {
                            let address = addresses[index]
                            Task { await feature.deleteAddress(address.id) }
                        }
                    }
                }
            } else {
                ContentUnavailableView {
                    Label("address.empty.title", systemImage: "mappin.slash")
                } description: {
                    Text("address.empty.description")
                } actions: {
                    Button("address.add") { showingAddForm = true }
                        .buttonStyle(.borderedProminent)
                }
            }
        }
        .navigationTitle("account.addresses")
        .toolbar {
            if feature.user?.addresses.isEmpty == false {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingAddForm = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddForm) {
            NavigationStack {
                AddressFormView(feature: feature, address: nil)
            }
        }
        .sheet(item: $editingAddress) { address in
            NavigationStack {
                AddressFormView(feature: feature, address: address)
            }
        }
    }

    private func addressRow(_ address: Address) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            HStack {
                Text(address.label)
                    .font(.headline)
                if address.isDefault {
                    Text("badge.default")
                        .font(.caption2.bold())
                        .padding(.horizontal, AppSpacing.sm)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(Color.accentColor.opacity(0.15)))
                        .foregroundStyle(Color.accentColor)
                }
                Spacer()
                Button("action.edit") { editingAddress = address }
                    .font(.subheadline)
            }
            Text(address.fullName)
                .font(.subheadline)
            Text(address.formattedAddress)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            if !address.phone.isEmpty {
                Text(address.phone)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, AppSpacing.xs)
    }
}

extension Address: @retroactive Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct AddressFormView: View {
    @Bindable var feature: AccountFeature
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
    @State private var isDefault = false

    private var isEditing: Bool { address != nil }

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
                TextField(text: $phone) { Text("form.phone") }
                    .textContentType(.telephoneNumber)
                    .keyboardType(.phonePad)
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
            }

            Section {
                Toggle("form.setDefaultAddress", isOn: $isDefault)
            }
        }
        .navigationTitle(isEditing ? "address.edit" : "address.add")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("nav.cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("action.save") { save() }
                    .disabled(fullName.isEmpty || street.isEmpty || city.isEmpty || state.isEmpty || zipCode.isEmpty)
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
                isDefault = address.isDefault
            } else if let user = feature.user {
                fullName = user.fullName
                phone = user.phone ?? ""
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
            isDefault: isDefault
        )
        Task {
            if isEditing {
                await feature.updateAddress(newAddress)
            } else {
                await feature.addAddress(newAddress)
            }
            dismiss()
        }
    }
}
