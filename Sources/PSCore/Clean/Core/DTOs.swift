//
//  DTOs.swift
//  
//
//  Created by Tiago Ferreira on 28/04/2023.
//

import Foundation

/// The Input DTO
public protocol DTOInput: CustomStringConvertible {
    // swiftlint:disable:next type_name
    associatedtype ID: Identificator
    var id: ID { get }
}

/// The Output DTO
public protocol DTOOutput {
    associatedtype Input
    init(input: Input)
}
