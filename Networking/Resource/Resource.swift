import Foundation

protocol ResourceDecoder {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

struct Resource<Request: Encodable, Response: Decodable> {
    let endpoint: String
    let queryParameters: [URLQueryItem]?
    let method: HTTPMethod
    let body: HTTPBody<Request>?
    let decoder: ResourceDecoder

    init(endpoint: String,
         queryParameters: [URLQueryItem]? = nil,
         method: HTTPMethod = .get,
         body: HTTPBody<Request>? = nil,
         decoder: ResourceDecoder = JSONDecoder()) {
        self.endpoint = endpoint
        self.queryParameters = queryParameters
        self.method = method
        self.body = body
        self.decoder = decoder
    }
}
