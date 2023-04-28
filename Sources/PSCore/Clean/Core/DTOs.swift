//
//  DTOs.swift
//  
//
//  Created by Tiago Ferreira on 28/04/2023.
//

import Foundation

public protocol DTOInput: CustomStringConvertible {
    // swiftlint:disable:next type_name
    associatedtype ID: Identificator
    var id: ID { get }
}
public protocol DTOOutput {
    associatedtype Input: DTOInput
    init(input: Input)
}
