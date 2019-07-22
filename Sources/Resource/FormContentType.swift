import Foundation

struct FormContentType: ContentType {
    var header: HTTP.Header {
        return ("Content-Type", "application/x-www-form-urlencoded")
    }

    var encoder: ContentTypeEncoder? {
        return FormEncoder()
    }

    var decoder: ContentTypeDecoder? {
      return nil
    }
}
