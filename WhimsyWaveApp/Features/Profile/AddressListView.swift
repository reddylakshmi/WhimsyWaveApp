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
                    Label("No Addresses", systemImage: "mappin.slash")
                } description: {
                    Text("Add a shipping address to get started.")
                } actions: {
                    Button("Add Address") { showingAddForm = true }
                        .buttonStyle(.borderedProminent)
                }
            }
        }
        .navigationTitle("Addresses")
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
                    Text("Default")
                        .font(.caption2.bold())
                        .padding(.horizontal, AppSpacing.sm)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(Color.accentColor.opacity(0.15)))
                        .foregroundStyle(Color.accentColor)
                }
                Spacer()
                Button("Edit") { editingAddress = address }
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
            Section("Address Label") {
                Picker("Label", selection: $label) {
                    Text("Home").tag("Home")
                    Text("Office").tag("Office")
                    Text("Other").tag("Other")
                }
                .pickerStyle(.segmented)
            }

            Section("Contact") {
                TextField("Full Name", text: $fullName)
                    .textContentType(.name)
                TextField("Phone", text: $phone)
                    .textContentType(.telephoneNumber)
                    .keyboardType(.phonePad)
            }

            Section("Address") {
                TextField("Street Address", text: $street)
                    .textContentType(.streetAddressLine1)
                TextField("Apt, Suite, Unit (optional)", text: $apartment)
                    .textContentType(.streetAddressLine2)
                TextField("City", text: $city)
                    .textContentType(.addressCity)
                TextField("State", text: $state)
                    .textContentType(.addressState)
                TextField("ZIP Code", text: $zipCode)
                    .textContentType(.postalCode)
                    .keyboardType(.numberPad)
            }

            Section {
                Toggle("Set as default address", isOn: $isDefault)
            }
        }
        .navigationTitle(isEditing ? "Edit Address" : "Add Address")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { save() }
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
