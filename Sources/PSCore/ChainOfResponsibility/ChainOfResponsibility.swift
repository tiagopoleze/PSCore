/// Protocol that defines the behavior of a chain of responsibility.
public protocol ChainingOfResponsibility {
    /// The type-erased next chain in the sequence.
    associatedtype Input
    /// The type-erased next chain in the sequence.
    associatedtype Output
    
    /// The condition that determines if the chain should handle the input.
    var shouldProcess: (Input) -> Bool { get }
    
    /// The result that is produced when the chain handles the input.
    var process: (Input) -> Output { get }
    
    /// The next chain in the sequence.
    var nextHandler: (any ChainingOfResponsibility)? { get }
    
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
        if shouldProcess(input) { return process(input) }
        guard let next = nextHandler as? ChainOfResponsibility<Input, Output> else {
            throw ChainOfResponsibilityError.noEqualChainOfResponsibility
        }
        return try next.execute(input: input)
    }
}

/// A concrete implementation of the `ChainingOfResponsibility` protocol.
public struct ChainOfResponsibility<IncomingData, ResultData>: ChainingOfResponsibility {
    public let shouldProcess: (IncomingData) -> Bool
    public let process: (IncomingData) -> ResultData
    public let nextHandler: (any ChainingOfResponsibility)?
    
    /// Initializes a new instance of `ChainOfResponsibility`.
    /// - Parameters:
    ///   - nextHandler: The next chain in the sequence.
    ///   - shouldProcess: The condition that determines if the chain should handle the input.
    ///   - process: The result that is produced when the chain handles the input.
    public init(
        nextHandler: (any ChainingOfResponsibility)? = nil,
        shouldProcess: @escaping (IncomingData) -> Bool,
        process: @escaping (IncomingData) -> ResultData
    ) {
        self.nextHandler = nextHandler
        self.shouldProcess = shouldProcess
        self.process = process
    }
}

/// Errors that can occur during the execution of the chain of responsibility.
public enum ChainOfResponsibilityError: Error {
    /// Indicates that the next chain is not of the same type.
    case noEqualChainOfResponsibility
}
