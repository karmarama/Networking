import Foundation

public struct EmptyDecoder: ResourceDecoder {
    public func decode<Value>(_ type: Value.Type,
                              from data: Data?,
                              response: HTTPURLResponse) throws -> Value where Value : Decodable {
        return Empty() as! Value
    }
}
