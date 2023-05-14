public class MockDecoder {

    public init() {}

    public func decode<T: Decodable>(
        _ type: T.Type,
        from dataProvider: [String: Any]
    ) throws -> T {
        let decoder = MockDecoderContainerProvider(dataProvider: dataProvider)

        guard let value = try decoder.decode(as: type) else {
            throw DecodingError
                .typeMismatch(
                    type.self,
                    DecodingError
                        .Context(
                            codingPath: decoder.codingPath,
                            debugDescription: "Couldn't map \(dataProvider) to \(type)"
                        )
                )
        }

        return value
    }
}

private class MockDecoderContainerProvider: Decoder {
    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey: Any] = [:]
    private let dataProvider: [String: Any]

    init(dataProvider: [String: Any]) {
        self.dataProvider = dataProvider
    }

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
        let container = MockKeyedDecoderContainer<Key>(dataProvider: dataProvider)
        return KeyedDecodingContainer(container)
    }

    func decode<T: Decodable>(as type: T.Type) throws -> T? {
        return try type.init(from: self)
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        fatalError("Only keyed containers are currently supported")
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        fatalError("Only keyed containers are currently supported")
    }
}

private class MockKeyedDecoderContainer<K: CodingKey>: KeyedDecodingContainerProtocol {
    var codingPath: [CodingKey] = []
    var allKeys: [K] = []
    private let dataProvider: [String: Any]

    init(dataProvider: [String: Any]) {
        self.dataProvider = dataProvider
    }

    func contains(_ key: K) -> Bool {
        return dataProvider[key.stringValue] != nil
    }

    func decodeNil(forKey key: K) throws -> Bool {
        return dataProvider[key.stringValue] == nil
    }

    private func retrieve<T>(_ type: T.Type, forKey key: K) throws -> T where T: Decodable {
        guard let decoded = dataProvider[key.stringValue] as? T else {
            throw DecodingError
                .typeMismatch(
                    type.self,
                    DecodingError
                        .Context(
                            codingPath: codingPath,
                            // swiftlint:disable:next line_length
                            debugDescription: "Expected a type \(type) but found \(String(describing: dataProvider[key.stringValue].self)) instead"
                        )
                )
        }

        return decoded
    }

    func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T: Decodable {
        try retrieve(type, forKey: key)
    }

    func decode(_ type: Bool.Type, forKey key: K) throws -> Bool {
        try retrieve(Bool.self, forKey: key)
    }

    func decode(_ type: String.Type, forKey key: K) throws -> String {
        try retrieve(String.self, forKey: key)
    }

    func decode(_ type: Double.Type, forKey key: K) throws -> Double {
        try retrieve(Double.self, forKey: key)
    }

    func decode(_ type: Float.Type, forKey key: K) throws -> Float {
        try retrieve(Float.self, forKey: key)
    }

    func decode(_ type: Int.Type, forKey key: K) throws -> Int {
        try retrieve(Int.self, forKey: key)
    }

    func decode(_ type: Int8.Type, forKey key: K) throws -> Int8 {
        try retrieve(Int8.self, forKey: key)
    }

    func decode(_ type: Int16.Type, forKey key: K) throws -> Int16 {
        try retrieve(Int16.self, forKey: key)
    }

    func decode(_ type: Int32.Type, forKey key: K) throws -> Int32 {
        try retrieve(Int32.self, forKey: key)
    }

    func decode(_ type: Int64.Type, forKey key: K) throws -> Int64 {
        try retrieve(Int64.self, forKey: key)
    }

    func decode(_ type: UInt.Type, forKey key: K) throws -> UInt {
        try retrieve(UInt.self, forKey: key)
    }

    func decode(_ type: UInt8.Type, forKey key: K) throws -> UInt8 {
        try retrieve(UInt8.self, forKey: key)
    }

    func decode(_ type: UInt16.Type, forKey key: K) throws -> UInt16 {
        try retrieve(UInt16.self, forKey: key)
    }

    func decode(_ type: UInt32.Type, forKey key: K) throws -> UInt32 {
        try retrieve(UInt32.self, forKey: key)
    }

    func decode(_ type: UInt64.Type, forKey key: K) throws -> UInt64 {
        try retrieve(UInt64.self, forKey: key)
    }

    func nestedContainer<NestedKey>(
        keyedBy type: NestedKey.Type,
        forKey key: K
    ) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
        fatalError("Currently not supported")
    }

    func nestedUnkeyedContainer(forKey key: K) throws -> UnkeyedDecodingContainer {
        fatalError("Currently not supported")
    }

    func superDecoder() throws -> Decoder {
        fatalError("Currently not supported")
    }

    func superDecoder(forKey key: K) throws -> Decoder {
        fatalError("Currently not supported")
    }
}
