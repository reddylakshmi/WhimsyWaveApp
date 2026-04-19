import Foundation

struct Address: Identifiable, Equatable, Sendable, Codable {
    let id: String
    var label: String
    var fullName: String
    var street: String
    var apartment: String?
    var city: String
    var state: String
    var zipCode: String
    var country: String
    var phone: String
    var isDefault: Bool

    init(
        id: String = UUID().uuidString,
        label: String = "Home",
        fullName: String,
        street: String,
        apartment: String? = nil,
        city: String,
        state: String,
        zipCode: String,
        country: String = "US",
        phone: String = "",
        isDefault: Bool = false
    ) {
        self.id = id
        self.label = label
        self.fullName = fullName
        self.street = street
        self.apartment = apartment
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.country = country
        self.phone = phone
        self.isDefault = isDefault
    }

    var formattedAddress: String {
        var lines = [street]
        if let apartment, !apartment.isEmpty { lines.append(apartment) }
        lines.append("\(city), \(state) \(zipCode)")
        return lines.joined(separator: "\n")
    }
}
