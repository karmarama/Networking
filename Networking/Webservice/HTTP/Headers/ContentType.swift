import Foundation

public protocol ContentType {
    var header: HTTPHeader { get }
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
    public var header: HTTPHeader {
        return ("Content-Type","application/json")
    }

    public var encoder: ContentTypeEncoder {
        return JSONEncoder()
    }

    public var decoder: ContentTypeDecoder {
        return JSONDecoder()
    }
}

extension JSONEncoder: ContentTypeEncoder {}
extension JSONDecoder: ContentTypeDecoder {}
