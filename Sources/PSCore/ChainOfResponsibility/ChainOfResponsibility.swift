//
//  ChainOfResponsibility.swift
//  
//
//  Created by Tiago Ferreira on 02/05/2023.
//

public protocol ChainingOfResponsibility {
    associatedtype Input
    associatedtype Output
    var condition: (Input) -> Bool { get }
    var result: (Input) -> Output { get }
    var next: (any ChainingOfResponsibility)? { get }

    func execute(input: Input) throws -> Output
}

public struct ChainOfResponsibility<Input, Output>: ChainingOfResponsibility {
    public let condition: (Input) -> Bool
    public let result: (Input) -> Output
    public let next: (any ChainingOfResponsibility)?

    public init(next: (any ChainingOfResponsibility)? = nil, condition: @escaping (Input) -> Bool, result: @escaping (Input) -> Output) {
        self.next = next
        self.condition = condition
        self.result = result
    }

    public func execute(input: Input) throws -> Output {
        if condition(input) { return result(input) }
        guard let next else { throw ChainOfResponsibilityError.noNextCase }
        guard let next = next as? ChainOfResponsibility<Input, Output> else { throw ChainOfResponsibilityError.noEqualChainOfResponsibility }
        return try next.execute(input: input)
    }
}

public enum ChainOfResponsibilityError: Error {
    case noNextCase
    case noEqualChainOfResponsibility
}
