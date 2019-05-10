import Foundation

extension URLRequest {
    init<Request: Encodable, Response: Decodable>(resource: Resource<Request, Response>, baseURL: URL) throws {
        var components = URLComponents(url: baseURL,
                                       resolvingAgainstBaseURL: false)!

        components.queryItems = resource.queryParameters

        self = URLRequest(url: components.url!)

        if let body = resource.body {
            httpBody = try body.encoded()

            var fields = allHTTPHeaderFields
            let (key, value) = body.contentType.header
            fields?[key] = value

            allHTTPHeaderFields = fields
        }

        httpMethod = resource.method.rawValue
    }
}
