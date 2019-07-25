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
