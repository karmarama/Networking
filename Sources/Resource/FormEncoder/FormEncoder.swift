//based on https://stackoverflow.com/questions/45169254/custom-swift-encoder-decoder-for-strings-resource-format
import Foundation

public class FormEncoder: ContentTypeEncoder {

    enum Error: Swift.Error {
        case formEncodingError
        case missingKeyForValue
        case unsupportedDataFormat
    }
    public func encode<T>(_ value: T) throws -> Data where T: Encodable {
        guard let stringData = try stringEncode(value).data(using: .utf8) else { throw Error.formEncodingError }

        return stringData
    }

    // returns a Form encoded representation of value
    public func stringEncode<T: Encodable>(_ value: T) throws -> String {
        let formEncoding = FormEncoding()
        try value.encode(to: formEncoding)
        return formFormat(from: formEncoding.data.strings)
    }

    private func formFormat(from strings: [String: String]) -> String {
       return strings.map { "\($0.escaped())=\($1.escaped())" }.sorted().joined(separator: "&")
    }
}

private struct FormEncoding: Encoder {

    //stores data during encoding

    fileprivate var data: FormData

    init(to encodedData: FormData = FormData()) {
        self.data = encodedData
    }

    var codingPath: [CodingKey] = []

    let userInfo: [CodingUserInfoKey: Any] = [:]

    func container<Key: CodingKey>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> {
        var container = FormKeyedEncoding<Key>(to: data)
        container.codingPath = codingPath
        return KeyedEncodingContainer(container)
    }

    func unkeyedContainer() -> UnkeyedEncodingContainer {
        var container = FormUnkeyedEncoding(to: data)
        container.codingPath = codingPath
        return container
    }

    func singleValueContainer() -> SingleValueEncodingContainer {
        var container = FormSingleValueEncoding(to: data)
        container.codingPath = codingPath
        return container
    }
}

private struct FormKeyedEncoding<Key: CodingKey>: KeyedEncodingContainerProtocol {

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

private struct FormUnkeyedEncoding: UnkeyedEncodingContainer {
    var count: Int = 0

    private let data: FormData

    init(to data: FormData) {
        self.data = data
    }

    var codingPath: [CodingKey] = []

    mutating func encodeNil() throws {
     throw FormEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: Bool) throws {
     throw FormEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: String) throws {
      throw FormEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: Double) throws {
       throw FormEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: Float) throws {
        throw FormEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: Int) throws {
       throw FormEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: Int8) throws {
        throw FormEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: Int16) throws {
         throw FormEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: Int32) throws {
        throw FormEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: Int64) throws {
        throw FormEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: UInt) throws {
        throw FormEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: UInt8) throws {
        throw FormEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: UInt16) throws {
        throw FormEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: UInt32) throws {
        throw FormEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: UInt64) throws {
       throw FormEncoder.Error.unsupportedDataFormat
    }

    mutating func encode<T: Encodable>(_ value: T) throws {
       throw FormEncoder.Error.unsupportedDataFormat
    }

    mutating func nestedContainer<NestedKey: CodingKey>(
        keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> {
        let container = FormKeyedEncoding<NestedKey>(to: data)
        return KeyedEncodingContainer(container)
    }

    mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        let container = FormUnkeyedEncoding(to: data)
        return container
    }

    mutating func superEncoder() -> Encoder {
        let formEncoding = FormEncoding(to: data)
        return formEncoding
    }
}

private struct FormSingleValueEncoding: SingleValueEncodingContainer {

    private let data: FormData

    init(to data: FormData) {
        self.data = data
    }

    var codingPath: [CodingKey] = []

    mutating func encodeNil() throws {
         throw FormEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: Bool) throws {
        throw FormEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: String) throws {
       throw FormEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: Double) throws {
       throw FormEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: Float) throws {
        throw FormEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: Int) throws {
        throw FormEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: Int8) throws {
       throw FormEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: Int16) throws {
        throw FormEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: Int32) throws {
       throw FormEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: Int64) throws {
       throw FormEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: UInt) throws {
        throw FormEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: UInt8) throws {
        throw FormEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: UInt16) throws {
         throw FormEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: UInt32) throws {
         throw FormEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: UInt64) throws {
        throw FormEncoder.Error.unsupportedDataFormat
    }

    mutating func encode<T: Encodable>(_ value: T) throws {
         throw FormEncoder.Error.unsupportedDataFormat
    }
}

final class FormData {
    private(set) var strings: [String: String] = [:]

    func encode(key codingKey: [CodingKey], value: String) throws {
        guard !codingKey.isEmpty else { throw FormEncoder.Error.missingKeyForValue }
        let keys = codingKey.map { $0.stringValue }
        let bracketedKeys = keys.dropFirst().map { "[\($0)]" }.joined()
        let key = keys[0].appending(bracketedKeys)
        strings[key] = value
    }
}

extension String {
    func escaped() -> String {
        let plussesReplaced = self.replacingOccurrences(of: "+", with: "%2B")
        let ampersandsReplaced = plussesReplaced.replacingOccurrences(of: "&", with: "%26")
        let spacesReplaced = ampersandsReplaced.replacingOccurrences(of: " ", with: "+")
        return spacesReplaced.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }

    func unescaped() -> String {
     let putBackSpaces = self.replacingOccurrences(of: "+", with: " ")
     let putBackAmpersannds = putBackSpaces.replacingOccurrences(of: "%26", with: "&")
     let putBackPlusses = putBackAmpersannds.replacingOccurrences(of: "%2B", with: "+")
     return putBackPlusses.removingPercentEncoding ?? putBackPlusses
    }
}
