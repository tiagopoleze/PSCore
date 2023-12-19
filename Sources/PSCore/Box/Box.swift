/// A generic box type that wraps a raw value.
///
/// Use `Box` to encapsulate a value of any type and provide additional functionality.
/// It can be used to transform the raw value into a new type using the `map` method.

public struct Box<Parent, RawValue> {
    /// The raw value stored in the box.
    public var rawValue: RawValue
    
    /// Initializes a new box with the given raw value.
    /// - Parameter rawValue: The raw value to be stored in the box.
    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
    
    /// Initializes a new box with the given raw value.
    /// - Parameter rawValue: The raw value to be stored in the box.
    public init(_ rawValue: RawValue) {
        self.rawValue = rawValue
    }
    
    /// Transforms the raw value into a new type using the provided closure.
    ///
    /// - Parameter convert: A closure that takes the current raw value and returns a new value of a different type.
    /// - Returns: A new `Box` instance with the transformed raw value.
    public func map<NewRawValue>(_ convert: (RawValue) -> NewRawValue) -> Box<Parent, NewRawValue> {
        return .init(rawValue: convert(self.rawValue))
    }
}

extension Box: RawRepresentable { }
extension Box: Equatable where RawValue: Equatable {}
extension Box: Hashable where RawValue: Hashable {}

extension Box: Identifiable where RawValue: Identifiable {
    /// The ID type used by the `Box` struct.
    public typealias ID = RawValue.ID
    
    /// The ID of the `Box`.
    public var id: ID {
        return rawValue.id
    }
}

#if canImport(Foundation)
import Foundation
extension Box where RawValue == UUID {
    /// Initializes a new instance of `Box` with a random UUID.
    public init() {
        self.init(rawValue: UUID())
    }
    
    /// Initializes a new instance of `Box` with the specified UUID string.
    /// - Parameter string: The UUID string to initialize the `Box` with.
    /// - Returns: An optional `Box` instance if the UUID string is valid, otherwise `nil`.
    public init?(uuidString string: String) {
        guard let uuid = UUID(uuidString: string)
        else { return nil }
        self.init(uuid)
    }
}
#endif
