//
//  ChainOfResponsibility.swift
//  
//
//  Created by Tiago Ferreira on 02/05/2023.
//

/// Protocol you need to conform to use a Chain of Responsibility
public protocol ChainingOfResponsibility {
    associatedtype Input
    associatedtype Output
    var condition: (Input) -> Bool { get }
    var result: (Input) -> Output { get }
    var next: (any ChainingOfResponsibility)? { get }

    /// Execute the chain
    /// - Parameter input: The kind of data we need to validate and use to create the result of the chain
    /// - Returns: The return expected
    func execute(input: Input) throws -> Output
}

public extension ChainingOfResponsibility {
    func execute(input: Input) throws -> Output {
        if condition(input) { return result(input) }
        guard let next else { throw ChainOfResponsibilityError.noNextCase }
        guard let next = next as? ChainOfResponsibility<Input, Output> else {
            throw ChainOfResponsibilityError.noEqualChainOfResponsibility
        }
        return try next.execute(input: input)
    }
}

/// The generic Chain of Responsibility
public struct ChainOfResponsibility<Input, Output>: ChainingOfResponsibility {
    public let condition: (Input) -> Bool
    public let result: (Input) -> Output
    public let next: (any ChainingOfResponsibility)?

    /// ChainOfResponsibility initialiser
    /// - Parameters:
    ///   - next: The next element in the chain
    ///   - condition: The condition that needs to return true to stop the chain
    ///   - result: The way we need to tread the return of the chain
    public init(
        next: (any ChainingOfResponsibility)? = nil,
        condition: @escaping (Input) -> Bool,
        result: @escaping (Input) -> Output
    ) {
        self.next = next
        self.condition = condition
        self.result = result
    }
}

/// Error of the Chain of Responsibility
public enum ChainOfResponsibilityError: Error {
    case noNextCase
    case noEqualChainOfResponsibility
}
