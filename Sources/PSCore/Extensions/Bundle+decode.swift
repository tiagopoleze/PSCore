import Foundation
import OSLog

/// Extension for decoding JSON data from a file in the bundle.
public extension Bundle {
    /// Decodes the specified type from a JSON file in the bundle.
    /// - Parameters:
    ///   - type: The type to decode.
    ///   - file: The name of the JSON file.
    ///   - dateDecodingStrategy: The date decoding strategy to use. Default is `.deferredToDate`.
    ///   - keyDecodingStrategy: The key decoding strategy to use. Default is `.useDefaultKeys`.
    /// - Returns: The decoded value of the specified type.
    /// - Throws: An error if the decoding process fails.
    func decode<T: Decodable>(
        _ type: T.Type,
        from file: String,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    ) throws -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            throw BundleDecodeError.noValidURL("Failed to locate \(file) in bundle.")
        }
        guard let data = try? Data(contentsOf: url) else {
            throw BundleDecodeError.noContentTo(url)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            logDecodeError(error, file: file)
            throw error
        }
    }
    
    private func logDecodeError(_ error: Error, file: String) {
        if #available(iOS 14.0, macOS 11.0, *) {
            switch error {
            case DecodingError.keyNotFound(let key, let context):
                // swiftlint:disable:next line_length
                Logger.bundleDecoder.error("Failed to decode \(file) from bundle due to missing key '\(key.stringValue) - \(context.debugDescription)")
            case DecodingError.typeMismatch(_, let context):
                Logger.bundleDecoder.error("Failed to decode \(file) from bundle due to type mismatch - \(context.debugDescription)")
            case DecodingError.valueNotFound(let type, let context):
                // swiftlint:disable:next line_length
                Logger.bundleDecoder.error("Failed to decode \(file) from bundle due to missing \(type) value - \(context.debugDescription)")
            case DecodingError.dataCorrupted(_):
                Logger.bundleDecoder.error("Failed to decode \(file) from bundle because it appears to be invalid JSON.")
            default:
                Logger.bundleDecoder.error("Failed to decode \(file) from bundle: \(error.localizedDescription)")
            }
        }
    }
}

/// An enumeration representing errors that can occur during decoding operations in a Bundle.
public enum BundleDecodeError: Error {
    case noValidURL(String)
    case noContentTo(URL)
}
