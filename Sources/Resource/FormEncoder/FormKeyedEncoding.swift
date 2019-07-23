import Foundation

struct FormKeyedEncoding<Key: CodingKey>: KeyedEncodingContainerProtocol {

    private let data: FormData

    init(to data: FormData) {
        self.data = data
    }

    var codingPath: [CodingKey] = []

    mutating func encodeNil(forKey key: Key) throws {
        try data.encode(key: codingPath + [key], value: "null")
    }

    mutating func encode(_ value: Bool, forKey key: Key) throws {
        try data.encode(key: codingPath + [key], value: value.description)
    }

    mutating func encode(_ value: String, forKey key: Key) throws {
        try data.encode(key: codingPath + [key], value: value)
    }

    mutating func encode(_ value: Double, forKey key: Key) throws {
        try data.encode(key: codingPath + [key], value: value.description)
    }

    mutating func encode(_ value: Float, forKey key: Key) throws {
        try data.encode(key: codingPath + [key], value: value.description)
    }

    mutating func encode(_ value: Int, forKey key: Key) throws {
        try  data.encode(key: codingPath + [key], value: value.description)
    }

    mutating func encode(_ value: Int8, forKey key: Key) throws {
        try data.encode(key: codingPath + [key], value: value.description)
    }

    mutating func encode(_ value: Int16, forKey key: Key) throws {
        try data.encode(key: codingPath + [key], value: value.description)
    }

    mutating func encode(_ value: Int32, forKey key: Key) throws {
        try data.encode(key: codingPath + [key], value: value.description)
    }

    mutating func encode(_ value: Int64, forKey key: Key) throws {
        try data.encode(key: codingPath + [key], value: value.description)
    }

    mutating func encode(_ value: UInt, forKey key: Key) throws {
        try data.encode(key: codingPath + [key], value: value.description)
    }

    mutating func encode(_ value: UInt8, forKey key: Key) throws {
        try data.encode(key: codingPath + [key], value: value.description)
    }

    mutating func encode(_ value: UInt16, forKey key: Key) throws {
        try data.encode(key: codingPath + [key], value: value.description)
    }

    mutating func encode(_ value: UInt32, forKey key: Key) throws {
        try data.encode(key: codingPath + [key], value: value.description)
    }

    mutating func encode(_ value: UInt64, forKey key: Key) throws {
        try data.encode(key: codingPath + [key], value: value.description)
    }

    mutating func encode<T: Encodable>(_ value: T, forKey key: Key) throws {
        var formEncoding = FormEncoding(to: data)
        formEncoding.codingPath.append(key)
        try value.encode(to: formEncoding)
    }

    mutating func nestedContainer<NestedKey: CodingKey>(
        keyedBy keyType: NestedKey.Type,
        forKey key: Key) -> KeyedEncodingContainer<NestedKey> {
        var container = FormKeyedEncoding<NestedKey>(to: data)
        container.codingPath = codingPath + [key]
        return KeyedEncodingContainer(container)
    }

    mutating func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        var container = FormUnkeyedEncoding(to: data)
        container.codingPath = codingPath + [key]
        return container
    }

    mutating func superEncoder() -> Encoder {
        let superKey = Key(stringValue: "super")!
        return superEncoder(forKey: superKey)
    }

    mutating func superEncoder(forKey key: Key) -> Encoder {
        var formEncoding = FormEncoding(to: data)
        formEncoding.codingPath = codingPath + [key]
        return formEncoding
    }
}
