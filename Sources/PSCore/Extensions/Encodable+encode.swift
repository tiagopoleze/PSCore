import Foundation

public extension Encodable {
    /// Encodes the encodable object into JSON data.
    /// - Parameters:
    ///   - outputFormatting: The output formatting for the JSON data. Default is `.prettyPrinted`.
    ///   - dateEncodingStrategy: The date encoding strategy for the JSON data. Default is `.iso8601`.
    ///   - keyEncodingStrategy: The key encoding strategy for the JSON data. Default is `.useDefaultKeys`.
    /// - Returns: The encoded JSON data, or `nil` if encoding fails.
    func encode(
        outputFormatting: JSONEncoder.OutputFormatting = .prettyPrinted,
        dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .iso8601,
        keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys
    ) -> Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = outputFormatting
        encoder.dateEncodingStrategy = dateEncodingStrategy
        encoder.keyEncodingStrategy = keyEncodingStrategy
        return try? encoder.encode(self)
    }
}
