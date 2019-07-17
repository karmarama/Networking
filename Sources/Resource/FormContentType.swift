import Foundation

struct FormContentType: ContentType {
    var header: HTTP.Header {
        return ("Content-Type", "application/x-www-form-urlencoded")
    }

    var encoder: ContentTypeEncoder {
        return FormEncoder()
    }

    var decoder: ContentTypeDecoder {
        return FormDecoder()
    }
}

class FormEncoder: ContentTypeEncoder {
    func encode<T>(_ value: T) throws -> Data where T: Encodable {
        let jsonData = try JSONEncoder().encode(value)
        guard let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            throw FormEncoderError.encodingError
        }
        let encodedAsString = json.map { "\($0.key)=\($0.value)"}.joined(separator: "&")
        if let data = encodedAsString.data(using: .utf8) {
            return data
        } else {
            throw FormEncoderError.encodingError
        }
    }
    enum FormEncoderError: Error {
        case encodingError
    }
}

class FormDecoder: ContentTypeDecoder {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        guard let string = String(data: data, encoding: .utf8) else {
            throw FormDecoderError.decodingError
        }
        let keyValuePairs = string.components(separatedBy: "&").map { $0.components(separatedBy: "=") }
        let tuples = keyValuePairs.compactMap { $0.asTuple()}
        let dict = tuples.reduce( [:], { (dictionary, tuple) -> [String: String] in
            var dictionary = dictionary
            dictionary[tuple.0] = tuple.1
            return dictionary
        })
        let jsonData = try JSONEncoder().encode(dict)
        return try JSONDecoder().decode(T.self, from: jsonData)
    }

    enum FormDecoderError: Error {
        case decodingError
    }
}

extension Array where Element == String {
    func asTuple() -> (String, String)? {
        guard count == 2 else { return nil }
        return (self[0], self[1])
    }
}

