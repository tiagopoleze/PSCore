public struct Box<Parent, RawValue> {
    public var rawValue: RawValue

    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: RawValue) {
        self.rawValue = rawValue
    }

    public func map<NewRawValue>(
        _ convert: (RawValue) -> NewRawValue
    ) -> Box<Parent, NewRawValue> {
        return .init(rawValue: convert(self.rawValue))
    }
}

extension Box: RawRepresentable { }
extension Box: Equatable where RawValue: Equatable {}
extension Box: Hashable where RawValue: Hashable {}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Box: Identifiable where RawValue: Identifiable {
    public typealias ID = RawValue.ID

    public var id: ID {
        return rawValue.id
    }
}

#if canImport(Foundation)
import Foundation
extension Box where RawValue == UUID {
    public init() {
        self.init(rawValue: UUID())
    }

    public init?(uuidString string: String) {
        guard let uuid = UUID(uuidString: string)
        else { return nil }
        self.init(uuid)
    }
}
#endif
