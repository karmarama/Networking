import Foundation

public class MirrorFormEncoder: ContentTypeEncoder {
    enum Error: Swift.Error {
        case formEncodingError
        case missingKeyForValue
    }
    public func encode<T>(_ value: T) throws -> Data where T: Encodable {
        guard let stringData = try stringEncode(value).data(using: .utf8) else { throw Error.formEncodingError }
        return stringData
    }

    public func stringEncode<T: Encodable>(_ value: T) throws -> String {
     let mirror = Mirror(reflecting: value)
        let labelledChildren = mirror.children.filter { $0.label != nil }
        let keyLabelPairs = labelledChildren.map { "\($0.label!.escaped())=\(String(describing: $0.value).escaped())" }
            .sorted()
            .joined(separator: "&")
        return keyLabelPairs
    }

}
