import Foundation

public struct EmptyDecoder: ResourceDecoder {
    public init() {}

    public func decode<Value: Decodable>(_ type: Value.Type,
                                         from data: Data?,
                                         response: HTTPURLResponse) throws -> Value {
        return Empty() as! Value //swiftlint:disable:this force_cast
    }
}
