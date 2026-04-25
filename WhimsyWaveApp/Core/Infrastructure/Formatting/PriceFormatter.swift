import Foundation

@MainActor
enum PriceFormatter {

    /// Formats a price using native Apple NumberFormatter with region-specific locale.
    /// The formatter automatically handles currency symbols, decimal separators,
    /// and grouping separators per the region's locale.
    static func format(_ value: Decimal, region: Region? = nil) -> String {
        let region = region ?? RegionManager.shared.currentRegion
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = region.currencyCode
        formatter.locale = region.locale
        return formatter.string(from: value as NSDecimalNumber) ?? "\(region.currencyCode) \(value)"
    }

    /// Formats a price or returns "FREE" (localized) for zero values
    static func formatOrFree(_ value: Decimal, region: Region? = nil) -> String {
        value == 0 ? String(localized: "price.free", defaultValue: "FREE") : format(value, region: region)
    }
}

// MARK: - Date Formatting

@MainActor
enum DateFormatter_App {

    /// Formats a date using the region's locale with medium date style.
    /// Example: "Apr 24, 2026" (en_US) or "24 avr. 2026" (fr_CA)
    static func formatMedium(_ date: Date, region: Region? = nil) -> String {
        let region = region ?? RegionManager.shared.currentRegion
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = region.locale
        return formatter.string(from: date)
    }

    /// Formats a date range for delivery estimates.
    /// Example: "Apr 24 – Apr 28" (en_US) or "24 avr. – 28 avr." (fr_CA)
    static func formatDeliveryRange(_ range: DateRange, region: Region? = nil) -> String {
        let region = region ?? RegionManager.shared.currentRegion
        let formatter = DateIntervalFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = region.locale
        return formatter.string(from: range.earliest, to: range.latest)
    }

    /// Formats a relative date string.
    /// Example: "2 days ago" (en_US) or "il y a 2 jours" (fr_CA)
    static func formatRelative(_ date: Date, region: Region? = nil) -> String {
        let region = region ?? RegionManager.shared.currentRegion
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = region.locale
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: .now)
    }
}

// MARK: - Number Formatting

@MainActor
enum NumberFormatter_App {

    /// Formats a number with proper grouping for the region.
    /// Example: "1,284" (en_US) or "1 284" (fr_CA)
    static func formatInteger(_ value: Int, region: Region? = nil) -> String {
        let region = region ?? RegionManager.shared.currentRegion
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = region.locale
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    /// Formats a percentage value.
    /// Example: "25%" (en_US) or "25 %" (fr_CA)
    static func formatPercentage(_ value: Int, region: Region? = nil) -> String {
        let region = region ?? RegionManager.shared.currentRegion
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.locale = region.locale
        formatter.multiplier = 1
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)%"
    }
}
