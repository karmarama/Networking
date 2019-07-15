import Foundation

public protocol ContentType {
    var header: HTTP.Header { get }
    var encoder: ContentTypeEncoder { get }
    var decoder: ContentTypeDecoder { get }
}

public protocol ContentTypeEncoder {
    func encode<T: Encodable>(_ value: T) throws -> Data
}

public protocol ContentTypeDecoder {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

public struct JSONContentType: ContentType {
    public var header: HTTP.Header {
        return ("Content-Type", "application/json")
    }

    public var encoder: ContentTypeEncoder {
        return JSONEncoder()
    }

    public var decoder: ContentTypeDecoder {
        return JSONDecoder()
    }

    public init() {}
}

extension JSONEncoder: ContentTypeEncoder {}
extension JSONDecoder: ContentTypeDecoder {}