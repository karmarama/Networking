import Foundation

public struct FormContentType: ContentType {

    public init() {}

    public  var header: HTTP.Header {
        return ("Content-Type", "application/x-www-form-urlencoded")
    }

    public var encoder: ContentTypeEncoder? {
        return FormEncoder()
    }

    public var decoder: ContentTypeDecoder? {
        return nil
    }
}
