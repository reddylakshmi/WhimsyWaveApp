import Foundation
import CryptoKit

/// Validates data integrity using SHA-256 checksums.
nonisolated enum ChecksumValidator {

    /// Computes the SHA-256 hash of the given data and returns it as a hex string.
    static func computeHash(of data: Data) -> String {
        let digest = SHA256.hash(data: data)
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    /// Validates that the given data matches the expected SHA-256 hash.
    static func validate(data: Data, expectedHash: String) -> Bool {
        let computed = computeHash(of: data)
        return computed == expectedHash.lowercased()
    }
}
