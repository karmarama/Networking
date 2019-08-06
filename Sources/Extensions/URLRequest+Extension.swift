import Foundation

extension URLRequest {
    public enum Error: String, Swift.Error {
        case malformedResource
        case malformedBaseURL
    }

    init<Request: Encodable, Response: Decodable>(resource: Resource<Request, Response>,
                                                  requestBehavior: RequestBehavior,
                                                  baseURL: URL) throws {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            throw Error.malformedBaseURL
        }

        components.path = components.path.appending(resource.endpoint)

        let queryItems = (components.queryItems ?? []) + resource.queryParameters

        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }

        components = requestBehavior
            .and(resource.requestBehavior)
            .modify(urlComponents: components)

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
