import Foundation

extension JSONDecoder: ResourceDecoder {
    public enum Error: Swift.Error {
        case noData
    }

    public func decode<Value: Decodable>(_ type: Value.Type,
                                         from data: Data?,
                                         response: HTTPURLResponse) throws -> Value {
            guard let data = data else {
                throw Error.noData
            }

            return try JSONDecoder().decode(type, from: data)
    }
}
