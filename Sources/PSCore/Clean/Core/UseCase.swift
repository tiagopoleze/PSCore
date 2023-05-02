//
//  UseCase.swift
//  
//
//  Created by Tiago Ferreira on 28/04/2023.
//

/// The default protocol use case
public protocol UseCase {
    associatedtype Input
    associatedtype Output
    /// The xecution call
    /// - Parameter input: The input parameter
    /// - Returns: The output object
    @discardableResult func execute(input: Input?) async throws -> Output
}
