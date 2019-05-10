import Foundation

extension URLRequest {
    public enum Error: String, Swift.Error {
        case malformedResource
        case malformedBaseURL
    }

    init<Request: Encodable, Response: Decodable>(resource: Resource<Request, Response>, baseURL: URL) throws {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            throw Error.malformedBaseURL
        }

        components.path = resource.endpoint

        let queryItems = (components.queryItems ?? []) + (resource.queryParameters ?? [])

        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }

        guard let url = components.url else {
            throw Error.malformedResource
        }

        self = URLRequest(url: url)

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
