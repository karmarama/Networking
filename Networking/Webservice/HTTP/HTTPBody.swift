import Foundation

public struct HTTPBody<Content: Encodable> {
    public let data: Content
    public let contentType: ContentType

    public func encoded() throws -> Data {
        return try contentType.encoder.encode(data)
    }
}
