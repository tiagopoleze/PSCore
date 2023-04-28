//
//  Encodable+encode.swift
//  
//
//  Created by Tiago Ferreira on 28/04/2023.
//

import Foundation

public extension Encodable {
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
