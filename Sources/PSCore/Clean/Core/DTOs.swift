//
//  DTOs.swift
//  
//
//  Created by Tiago Ferreira on 28/04/2023.
//

public protocol DTOInput: CustomStringConvertible {
    var id: ObjectIdentifier { get }
}
public protocol DTOOutput {
    associatedtype Input: DTOInput
    init(input: Input)
}
