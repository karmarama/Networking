import Foundation

final class FormData {
    private(set) var strings: [String: String] = [:]

    func encode(key codingKey: [CodingKey], value: String) throws {
        guard !codingKey.isEmpty,
            let first = codingKey.first?.stringValue else { throw FormEncoder.Error.missingKeyForValue }
        let keys = codingKey.map { $0.stringValue }
        let bracketedKeys = keys.dropFirst().map { "[\($0)]" }.joined()
        let key = first.appending(bracketedKeys)
        strings[key] = value
    }
}
