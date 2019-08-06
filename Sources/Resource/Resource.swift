import Foundation

public protocol ResourceDecoder {
    func decode<Value: Decodable>(_ type: Value.Type, from data: Data?, response: HTTPURLResponse) throws -> Value
}

public enum ResourceDecodingExecution {
    case background(ResourceDecoder)
    case qos(ResourceDecoder, DispatchQoS.QoSClass)
}

public struct Resource<Request: Encodable, Response: Decodable> {
    let endpoint: String
    let queryParameters: [URLQueryItem]
    let method: HTTP.Method
    let body: HTTP.Body<Request>?
    let requestBehavior: RequestBehavior
    let decoding: ResourceDecodingExecution

    public init(endpoint: String, //swiftlint:disable:this function_default_parameter_at_end
                queryParameters: [URLQueryItem] = [],
                method: HTTP.Method = .get,
                body: HTTP.Body<Request>? = nil,
                requestBehavior: RequestBehavior? = nil,
                decoding: ResourceDecodingExecution) {
            self.endpoint = endpoint
            self.queryParameters = queryParameters
            self.method = method
            self.body = body
            self.requestBehavior = requestBehavior ?? EmptyRequestBehavior()
            self.decoding = decoding
    }
}
