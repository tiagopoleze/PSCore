//
//  UseCase.swift
//  
//
//  Created by Tiago Ferreira on 28/04/2023.
//

public protocol UseCase {
    associatedtype Input: DTOInput
    associatedtype Output: DTOOutput
    @discardableResult func execute(input: Input?) async throws -> Output
}
