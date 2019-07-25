import Foundation

struct FormURLEncoding: Encoder {

    //stores data during encoding

    var data: FormURLData

    init(to encodedData: FormURLData = FormURLData()) {
        self.data = encodedData
    }

    var codingPath: [CodingKey] = []

    let userInfo: [CodingUserInfoKey: Any] = [:]

    func container<Key: CodingKey>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> {
        var container = FormURLKeyedEncoding<Key>(to: data)
        container.codingPath = codingPath
        return KeyedEncodingContainer(container)
    }

    func unkeyedContainer() -> UnkeyedEncodingContainer {
        var container = FormURLUnkeyedEncoding(to: data)
        container.codingPath = codingPath
        return container
    }

    func singleValueContainer() -> SingleValueEncodingContainer {
        var container = FormURLSingleValueEncoding(to: data)
        container.codingPath = codingPath
        return container
    }
}
