import Foundation

struct FormEncoding: Encoder {

    //stores data during encoding

    var data: FormData

    init(to encodedData: FormData = FormData()) {
        self.data = encodedData
    }

    var codingPath: [CodingKey] = []

    let userInfo: [CodingUserInfoKey: Any] = [:]

    func container<Key: CodingKey>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> {
        var container = FormKeyedEncoding<Key>(to: data)
        container.codingPath = codingPath
        return KeyedEncodingContainer(container)
    }

    func unkeyedContainer() -> UnkeyedEncodingContainer {
        var container = FormUnkeyedEncoding(to: data)
        container.codingPath = codingPath
        return container
    }

    func singleValueContainer() -> SingleValueEncodingContainer {
        var container = FormSingleValueEncoding(to: data)
        container.codingPath = codingPath
        return container
    }
}
