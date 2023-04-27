//
//  Bundle+decode.swift
//  
//
//  Created by Tiago Ferreira on 26/04/2023.
//

import Foundation

public extension Bundle {
    func decode<T: Decodable>(
        _ type: T.Type,
        from file: String,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    ) -> T? {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            return createError("Failed to locate \(file) in bundle.")
        }
        guard let data = try? Data(contentsOf: url) else {
            return createError("Failed to load \(file) in bundle")
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            // swiftlint:disable:next line_length
            return createError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue) - \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            // swiftlint:disable:next line_length
            return createError("Failed to decode \(file) from bundle due to type mismatch - \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            // swiftlint:disable:next line_length
            return createError("Failed to decode \(file) from bundle due to missing \(type) value - \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            return createError("Failed to decode \(file) from bundle because it appears to be invalid JSON.")
        } catch {
            return createError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }

    private func createError<T>(_ string: String) -> T? {
        print(string, logLevel: .error)
        return nil
    }
}
