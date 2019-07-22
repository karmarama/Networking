//
import Foundation

public class FormDecoder: Decoder {

    enum Error: Swift.Error {
        case keyRequired
        case valueNotFoundForKey
        case incompatibleType
        case nestingUnsupported
    }
    public var codingPath: [CodingKey] = []

    public var userInfo: [CodingUserInfoKey: Any] = [:]

    let stringToDecode: String
    init(_ string: String) {
        self.stringToDecode = string
    }

    public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
        return KeyedDecodingContainer(KDC(stringToDecode))
    }

    struct KDC<Key: CodingKey>: KeyedDecodingContainerProtocol {
        let stringDict: [String: Any]
        init(_ string: String) {
            let keyValueStrings = string.components(separatedBy: "&")
                .map { $0.components(separatedBy: "=")
                    .map { $0.unescaped() }
                }

            var dict: [String: Any] = [:]

            for keyValueString in keyValueStrings {
                guard keyValueString.count == 2 else {
                    assertionFailure("wrong number of values in array")
                    fatalError("ggggg")
                }

                let keySegments = keyValueString[0].segments()
                let value = keyValueString[1]
                dict[keyPath: KeyPath(segments: keySegments)] = value

            }
            self.stringDict = dict
        }

        var codingPath: [CodingKey] = []

        var allKeys: [Key] = []

        func contains(_ key: Key) -> Bool {
            return stringDict[key.stringValue] != nil
        }

        func decodeNil(forKey key: Key) throws -> Bool {
            if let value = stringDict[key.stringValue] as? String {
                return value == "null"
            }
            throw DecodingError.keyNotFound(key,
                                            DecodingError.Context(codingPath: codingPath, debugDescription: "TODO"))
        }

        func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
            if let value = stringDict[key.stringValue] as? String {
                switch value {
                case true.description:
                    return true
                case false.description:
                    return false
                default:
                    throw Error.incompatibleType
                }
            }
            throw DecodingError.keyNotFound(key,
                                            DecodingError.Context(codingPath: codingPath, debugDescription: "TODO"))
        }

        func decode(_ type: String.Type, forKey key: Key) throws -> String {
            if let value = stringDict[key.stringValue] as? String {
                return value
            }
            throw DecodingError.keyNotFound(key,
                                            DecodingError.Context(codingPath: codingPath, debugDescription: "TODO"))
        }

        func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
              if let value = stringDict[key.stringValue] as? String {
                if let double = Double(value) {
                    return double
                } else {
                    throw Error.incompatibleType
                }
            }
            throw DecodingError.keyNotFound(key,
                                            DecodingError.Context(codingPath: codingPath, debugDescription: "TODO"))
        }

        func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
              if let value = stringDict[key.stringValue] as? String {
                if let float = Float(value) {
                    return float
                } else {
                    throw Error.incompatibleType
                }
            }
            throw DecodingError.keyNotFound(key,
                                            DecodingError.Context(codingPath: codingPath, debugDescription: "TODO"))
        }

        func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
               if let value = stringDict[key.stringValue] as? String {
                if let int = Int(value) {
                    return int
                } else {
                    throw Error.incompatibleType
                }
            }
            throw DecodingError.keyNotFound(key,
                                            DecodingError.Context(codingPath: codingPath, debugDescription: "TODO"))
        }

        func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
               if let value = stringDict[key.stringValue] as? String {
                if let int8 = Int8(value) {
                    return int8
                } else {
                    throw Error.incompatibleType
                }
            }
            throw DecodingError.keyNotFound(key,
                                            DecodingError.Context(codingPath: codingPath, debugDescription: "TODO"))
        }

        func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
              if let value = stringDict[key.stringValue] as? String {
                if let int16 = Int16(value) {
                    return int16
                } else {
                    throw Error.incompatibleType
                }
            }
            throw DecodingError.keyNotFound(key,
                                            DecodingError.Context(codingPath: codingPath, debugDescription: "TODO"))
        }

        func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
             if let value = stringDict[key.stringValue] as? String {
                if let int32 = Int32(value) {
                    return int32
                } else {
                    throw Error.incompatibleType
                }
            }
            throw DecodingError.keyNotFound(key,
                                            DecodingError.Context(codingPath: codingPath, debugDescription: "TODO"))
        }

        func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
              if let value = stringDict[key.stringValue] as? String {
                if let int64 = Int64(value) {
                    return int64
                } else {
                    throw Error.incompatibleType
                }
            }
            throw DecodingError.keyNotFound(key,
                                            DecodingError.Context(codingPath: codingPath, debugDescription: "TODO"))
        }

        func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
              if let value = stringDict[key.stringValue] as? String {
                if let uint = UInt(value) {
                    return uint
                } else {
                    throw Error.incompatibleType
                }
            }
            throw DecodingError.keyNotFound(key,
                                            DecodingError.Context(codingPath: codingPath, debugDescription: "TODO"))
        }

        func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
               if let value = stringDict[key.stringValue] as? String {
                if let uint8 = UInt8(value) {
                    return uint8
                } else {
                    throw Error.incompatibleType
                }
            }
            throw DecodingError.keyNotFound(key,
                                            DecodingError.Context(codingPath: codingPath, debugDescription: "TODO"))
        }

        func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
              if let value = stringDict[key.stringValue] as? String {
                if let uint16 = UInt16(value) {
                    return uint16
                } else {
                    throw Error.incompatibleType
                }
            }
            throw DecodingError.keyNotFound(key,
                                            DecodingError.Context(codingPath: codingPath, debugDescription: "TODO"))
        }

        func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
              if let value = stringDict[key.stringValue] as? String {
                if let uint32 = UInt32(value) {
                    return uint32
                } else {
                    throw Error.incompatibleType
                }
            }
            throw DecodingError.keyNotFound(key,
                                            DecodingError.Context(codingPath: codingPath, debugDescription: "TODO"))
        }

        func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
              if let value = stringDict[key.stringValue] as? String {
                if let uint64 = UInt64(value) {
                    return uint64
                } else {
                    throw Error.incompatibleType
                }
            }
            throw DecodingError.keyNotFound(key,
                                            DecodingError.Context(codingPath: codingPath, debugDescription: "TODO"))
        }

        func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T: Decodable {
              if let value = stringDict[key.stringValue] as? String {
                let decoder = FormDecoder(value)
                return try T(from: decoder)
              } else if let nestedDict = stringDict[key.stringValue] as? [String: Any] {
                //TO DO:
                print(nestedDict)
                throw Error.nestingUnsupported
            }
            throw DecodingError.keyNotFound(key,
                                            DecodingError.Context(codingPath: codingPath, debugDescription: "TODO"))
        }

        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws
            -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
                fatalError("l")
        }

        func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
            throw Error.keyRequired
        }

        func superDecoder() throws -> Decoder {
            fatalError("l")
        }

        func superDecoder(forKey key: Key) throws -> Decoder {
            fatalError("l")
        }
    }

    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        throw Error.keyRequired
    }

    public func singleValueContainer() throws -> SingleValueDecodingContainer {
        throw Error.keyRequired
    }
}

extension String {
    func segments() -> [String] {
        let withoutEndBrackets = self.replacingOccurrences(of: "]", with: "")
        return withoutEndBrackets.components(separatedBy: "[")
    }
}
