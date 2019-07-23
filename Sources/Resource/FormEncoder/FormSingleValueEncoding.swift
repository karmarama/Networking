import Foundation

struct FormSingleValueEncoding: SingleValueEncodingContainer {

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
