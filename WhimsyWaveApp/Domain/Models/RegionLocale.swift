import Foundation

/// Represents a region-locale key used for routing assortment data.
/// Maps a `Region` to a string key like "US_EN" or "CA_FR".
nonisolated struct RegionLocale: Equatable, Hashable, Sendable, CustomStringConvertible {
    let key: String

    var description: String { key }

    /// Resolves the region-locale key from a `Region`.
    static func resolve(from region: Region) -> RegionLocale {
        switch region {
        case .us: return RegionLocale(key: "US_EN")
        case .uk: return RegionLocale(key: "UK_EN")
        case .ca: return RegionLocale(key: "CA_EN")
        case .caFR: return RegionLocale(key: "CA_FR")
        case .in: return RegionLocale(key: "IN_EN")
        }
    }

    /// The corresponding `Region` for this locale key.
    var region: Region {
        switch key {
        case "US_EN": return .us
        case "UK_EN": return .uk
        case "CA_EN": return .ca
        case "CA_FR": return .caFR
        case "IN_EN": return .in
        default: return .us
        }
    }

    /// The bundle resource name for this region's assortment file.
    var assortmentFileName: String { key }
}
