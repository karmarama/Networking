import Foundation

public struct HTTP {

    enum Error: Swift.Error {
        case noEncoder
    }
    public typealias Header = (String, String)
    public typealias StatusCode = Int

    public struct Body<Content: Encodable> {
        public let data: Content
        public let contentType: ContentType

        public init(data: Content, contentType: ContentType) {
            self.data = data
            self.contentType = contentType
        }

        public func encoded() throws -> Data {
            guard let encoder = contentType.encoder else {
                throw Error.noEncoder
            }
            return try encoder.encode(data)
        }
    }

    public enum Method: String {
        case get
        case post
        case put
        case patch
        case delete
        case head
        case connect
        case options
        case trace
    }
}
