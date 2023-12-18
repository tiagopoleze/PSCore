/// Protocol that defines the behavior of a chain of responsibility.
public protocol ChainingOfResponsibility {
    /// The type-erased next chain in the sequence.
    associatedtype Input
    /// The type-erased next chain in the sequence.
    associatedtype Output
    
    /// The condition that determines if the chain should handle the input.
    var condition: (Input) -> Bool { get }
    
    /// The result that is produced when the chain handles the input.
    var result: (Input) -> Output { get }
    
    /// The next chain in the sequence.
    var next: (any ChainingOfResponsibility)? { get }

    /// Executes the chain of responsibility with the given input.
    /// - Parameter input: The input to be processed by the chain.
    /// - Returns: The output produced by the chain.
    /// - Throws: An error if there is no next case or if the next chain is not of the same type.
    func execute(input: Input) throws -> Output
}

public extension ChainingOfResponsibility {
    /// Executes the chain of responsibility by passing the input through each handler until a condition is met.
    /// - Parameters:
    ///   - input: The input value to be processed by the chain of responsibility.
    /// - Returns: The output value produced by the chain of responsibility.
    /// - Throws: An error if no condition is met or if there is no next case in the chain.
    func execute(input: Input) throws -> Output {
        if condition(input) { return result(input) }
        guard let next else { throw ChainOfResponsibilityError.noNextCase }
        guard let next = next as? ChainOfResponsibility<Input, Output> else {
            throw ChainOfResponsibilityError.noEqualChainOfResponsibility
        }
        return try next.execute(input: input)
    }
}

/// A concrete implementation of the `ChainingOfResponsibility` protocol.
public struct ChainOfResponsibility<Input, Output>: ChainingOfResponsibility {
    public let condition: (Input) -> Bool
    public let result: (Input) -> Output
    public let next: (any ChainingOfResponsibility)?

    /// Initializes a new instance of `ChainOfResponsibility`.
    /// - Parameters:
    ///   - next: The next chain in the sequence.
    ///   - condition: The condition that determines if the chain should handle the input.
    ///   - result: The result that is produced when the chain handles the input.
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

/// Errors that can occur during the execution of the chain of responsibility.
public enum ChainOfResponsibilityError: Error {
    /// Indicates that there is no next case in the chain.
    case noNextCase
    
    /// Indicates that the next chain is not of the same type.
    case noEqualChainOfResponsibility
}
