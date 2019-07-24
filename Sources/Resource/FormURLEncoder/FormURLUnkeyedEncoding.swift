import Foundation

 struct FormURLUnkeyedEncoding: UnkeyedEncodingContainer {
    var count: Int = 0

    private let data: FormURLData

    init(to data: FormURLData) {
        self.data = data
    }

    var codingPath: [CodingKey] = []

    mutating func encodeNil() throws {
        throw FormURLEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: Bool) throws {
        throw FormURLEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: String) throws {
        throw FormURLEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: Double) throws {
        throw FormURLEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: Float) throws {
        throw FormURLEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: Int) throws {
        throw FormURLEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: Int8) throws {
        throw FormURLEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: Int16) throws {
        throw FormURLEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: Int32) throws {
        throw FormURLEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: Int64) throws {
        throw FormURLEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: UInt) throws {
        throw FormURLEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: UInt8) throws {
        throw FormURLEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: UInt16) throws {
        throw FormURLEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: UInt32) throws {
        throw FormURLEncoder.Error.unsupportedDataFormat
    }

    mutating func encode(_ value: UInt64) throws {
        throw FormURLEncoder.Error.unsupportedDataFormat
    }

    mutating func encode<T: Encodable>(_ value: T) throws {
        throw FormURLEncoder.Error.unsupportedDataFormat
    }

    mutating func nestedContainer<NestedKey: CodingKey>(
        keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> {
        let container = FormURLKeyedEncoding<NestedKey>(to: data)
        return KeyedEncodingContainer(container)
    }

    mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        let container = FormURLUnkeyedEncoding(to: data)
        return container
    }

    mutating func superEncoder() -> Encoder {
        let formEncoding = FormURLEncoding(to: data)
        return formEncoding
    }
}
