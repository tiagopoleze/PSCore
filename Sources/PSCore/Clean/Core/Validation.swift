//
//  File.swift
//  
//
//  Created by Tiago Ferreira on 28/04/2023.
//

public protocol Validation: CustomStringConvertible {
    func validate() async throws -> Bool
}
