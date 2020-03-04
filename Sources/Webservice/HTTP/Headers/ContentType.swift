import Foundation

public protocol ContentType {
    var header: HTTP.Header { get }
    var encoder: ContentTypeEncoder? { get }
    var decoder: ContentTypeDecoder? { get }
}

public protocol ContentTypeEncoder {
    func encode<T: Encodable>(_ value: T) throws -> Data
}

public protocol ContentTypeDecoder {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

public struct JSONContentType: ContentType {

    public enum CharSet {
        case utf8
        case iso88591
        case custom(String)

        var stringValue: String {
            switch self {
            case .utf8:
                return "UTF-8"
            case .iso88591:
                return "ISO-8859-1"
            case .custom(let value):
                return value
            }
        }
    }

    private let charSet: CharSet?
    private let _encoder: JSONEncoder
    private let _decoder: JSONDecoder

    public var header: HTTP.Header {

        if let charSet = charSet {
            return ("Content-Type", "application/json; charset=\(charSet.stringValue)")
        }
        return ("Content-Type", "application/json")
    }

    public var encoder: ContentTypeEncoder? {
        return _encoder
    }

    public var decoder: ContentTypeDecoder? {
        return _decoder
    }

    public init(charSet: CharSet? = nil,
                encoder: JSONEncoder = JSONEncoder(),
                decoder: JSONDecoder = JSONDecoder()) {
        self.charSet = charSet
        self._encoder = encoder
        self._decoder = decoder
    }
}

extension JSONEncoder: ContentTypeEncoder {}
extension JSONDecoder: ContentTypeDecoder {}
