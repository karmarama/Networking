//based on https://stackoverflow.com/questions/45169254/custom-swift-encoder-decoder-for-strings-resource-format
import Foundation

public class FormURLEncoder: ContentTypeEncoder {

    enum Error: Swift.Error {
        case formEncodingError
        case missingKeyForValue
        case unsupportedDataFormat
    }
    public func encode<T>(_ value: T) throws -> Data where T: Encodable {
        return try Data(stringEncode(value).utf8)
    }

    // returns a Form encoded representation of value
    public func stringEncode<T: Encodable>(_ value: T) throws -> String {
        let formEncoding = FormURLEncoding()
        try value.encode(to: formEncoding)
        return formFormat(from: formEncoding.data.strings)
    }

    private func formFormat(from strings: [String: String]) -> String {
        var urlComponents = URLComponents()
        urlComponents.queryItems = strings.map { URLQueryItem(name: $0.formEncoded(), value: $1.formEncoded()) }
            .sorted { $0.name < $1.name }
        return urlComponents.queryString
    }
}
