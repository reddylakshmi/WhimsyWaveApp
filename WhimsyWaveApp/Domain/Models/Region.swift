import Foundation

enum Region: String, CaseIterable, Identifiable, Codable, Sendable {
    case us = "US"
    case uk = "UK"
    case ca = "CA"
    case caFR = "CA-FR"
    case `in` = "IN"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .us: return String(localized: "region.us", defaultValue: "United States")
        case .uk: return String(localized: "region.uk", defaultValue: "United Kingdom")
        case .ca: return String(localized: "region.ca", defaultValue: "Canada (English)")
        case .caFR: return String(localized: "region.caFR", defaultValue: "Canada (Français)")
        case .in: return String(localized: "region.in", defaultValue: "India")
        }
    }

    var flag: String {
        switch self {
        case .us: return "🇺🇸"
        case .uk: return "🇬🇧"
        case .ca, .caFR: return "🇨🇦"
        case .in: return "🇮🇳"
        }
    }

    var currencyCode: String {
        switch self {
        case .us: return "USD"
        case .uk: return "GBP"
        case .ca, .caFR: return "CAD"
        case .in: return "INR"
        }
    }

    var currencySymbol: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.locale = locale
        return formatter.currencySymbol
    }

    var locale: Locale {
        switch self {
        case .us: return Locale(identifier: "en_US")
        case .uk: return Locale(identifier: "en_GB")
        case .ca: return Locale(identifier: "en_CA")
        case .caFR: return Locale(identifier: "fr_CA")
        case .in: return Locale(identifier: "en_IN")
        }
    }

    /// The language identifier used for String Catalog lookups and CMS content
    var languageCode: String {
        switch self {
        case .us, .uk, .ca, .in: return "en"
        case .caFR: return "fr"
        }
    }

    var taxRate: Decimal {
        switch self {
        case .us: return Decimal(string: "0.0825")!
        case .uk: return Decimal(string: "0.20")!
        case .ca, .caFR: return Decimal(string: "0.13")!
        case .in: return Decimal(string: "0.18")!
        }
    }

    var freeShippingThreshold: Decimal {
        switch self {
        case .us: return 49
        case .uk: return 40
        case .ca, .caFR: return 65
        case .in: return 999
        }
    }

    var standardShippingCost: Decimal {
        switch self {
        case .us: return Decimal(string: "9.99")!
        case .uk: return Decimal(string: "5.99")!
        case .ca, .caFR: return Decimal(string: "12.99")!
        case .in: return Decimal(string: "149")!
        }
    }

    /// Conversion factor relative to USD for mock price generation
    var priceMultiplier: Decimal {
        switch self {
        case .us: return 1
        case .uk: return Decimal(string: "0.79")!
        case .ca, .caFR: return Decimal(string: "1.36")!
        case .in: return Decimal(string: "83.50")!
        }
    }

    /// Measurement system used in this region
    var usesMetric: Bool {
        switch self {
        case .us: return false
        default: return true
        }
    }
}

// MARK: - Decimal Rounding Helper

extension Decimal {
    /// Rounds to 2 decimal places using banker's rounding
    var roundedToTwo: Decimal {
        var result = Decimal()
        var value = self
        NSDecimalRound(&result, &value, 2, .plain)
        return result
    }
}
