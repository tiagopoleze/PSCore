import Foundation

public extension Bundle {
    // swiftlint:disable:next cyclomatic_complexity
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
        } catch DecodingError.keyNotFound(let key, let context) {
            if #available(iOS 14.0, macOS 11.0, *) {
                // swiftlint:disable:next line_length
                print("Failed to decode \(file) from bundle due to missing key '\(key.stringValue) - \(context.debugDescription)", logLevel: .error)
            }
            throw DecodingError.keyNotFound(key, context)
        } catch DecodingError.typeMismatch(let key, let context) {
            if #available(iOS 14.0, macOS 11.0, *) {
                // swiftlint:disable:next line_length
                print("Failed to decode \(file) from bundle due to type mismatch - \(context.debugDescription)", logLevel: .error)
            }
            throw DecodingError.typeMismatch(key, context)
        } catch DecodingError.valueNotFound(let type, let context) {
            if #available(iOS 14.0, macOS 11.0, *) {
                // swiftlint:disable:next line_length
                print("Failed to decode \(file) from bundle due to missing \(type) value - \(context.debugDescription)", logLevel: .error)
            }
            throw DecodingError.valueNotFound(type, context)
        } catch DecodingError.dataCorrupted(let error) {
            if #available(iOS 14.0, macOS 11.0, *) {
                print("Failed to decode \(file) from bundle because it appears to be invalid JSON.", logLevel: .error)
            }
            throw DecodingError.dataCorrupted(error)
        } catch {
            if #available(iOS 14.0, macOS 11.0, *) {
                print("Failed to decode \(file) from bundle: \(error.localizedDescription)", logLevel: .error)
            }
            throw error
        }
    }
}

public enum BundleDecodeError: Error {
    case noValidURL(String)
    case noContentTo(URL)
}
