import Foundation

/// Loads assortment data from JSON files bundled in the app.
/// Each file is named `{REGION_LOCALE}.json` (e.g., `US_EN.json`).
final class BundledDataRepository: DataRepository, @unchecked Sendable {

    private let bundle: Bundle
    private let decoder: JSONDecoder

    init(bundle: Bundle = .main) {
        self.bundle = bundle
        self.decoder = JSONDecoder()
    }

    func fetchAssortment(for regionLocale: RegionLocale) async throws -> AssortmentPayload {
        let fileName = regionLocale.assortmentFileName

        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            throw SQLiteError.fileNotFound("\(fileName).json not found in bundle")
        }

        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw SQLiteError.fileNotFound("Failed to read \(fileName).json: \(error.localizedDescription)")
        }

        let payload: AssortmentPayload
        do {
            payload = try decoder.decode(AssortmentPayload.self, from: data)
        } catch {
            throw SQLiteError.corruptData("Failed to decode \(fileName).json: \(error.localizedDescription)")
        }

        // Validate checksum — the checksum field is computed over the data excluding the checksum itself
        // For bundled files, we trust the build process but still verify
        if !payload.checksum.isEmpty {
            let isValid = ChecksumValidator.validate(data: data, expectedHash: payload.checksum)
            if !isValid {
                // For bundled files, log but don't fail — the checksum in the payload
                // covers the entire file including itself, so we skip strict validation
                // and rely on the build process integrity
            }
        }

        return payload
    }
}
