import Foundation

public struct HTTP {
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
            return try contentType.encoder.encode(data)
        }
    }

    public enum Method: String {
        case get
        case post
        case put
        case delete
        case head
        case connect
        case options
        case trace
    }
}
