import Foundation

public struct HeaderProvider: RequestBehavior {
    private let headers: [HTTP.Header]

    public init(headers: [HTTP.Header]) {
        self.headers = headers
    }

    public func modify(planned request: URLRequest) -> URLRequest {
        var request = request
        var allHeaders = request.allHTTPHeaderFields ?? [String: String]()

        for (header, value) in headers {
            allHeaders[header] = value
        }

        request.allHTTPHeaderFields = allHeaders
        return request
    }
}
