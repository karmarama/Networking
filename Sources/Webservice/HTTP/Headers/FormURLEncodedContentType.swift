import Foundation

public struct FormURLEncodedContentType: ContentType {

    public init() {}

    public  var header: HTTP.Header {
        return ("Content-Type", "application/x-www-form-urlencoded")
    }

    public var encoder: ContentTypeEncoder? {
        return FormURLEncoder()
    }

    public var decoder: ContentTypeDecoder? {
        return nil
    }
}
