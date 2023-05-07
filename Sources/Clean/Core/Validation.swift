//
//  File.swift
//  
//
//  Created by Tiago Ferreira on 28/04/2023.
//

/// A protocol to validate data
public protocol Validation: CustomStringConvertible {
    func validate() async throws -> Bool
}
