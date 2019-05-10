import Foundation

protocol ResourceRequestable {
    func load<Request: Encodable, Response: Decodable>(_ resource: Resource<Request, Response>,
                                                       completion: @escaping (Result<Response, Error>) -> Void)
}

protocol URLSessionDataTaskLoader {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

typealias HTTPStatusCode = Int

struct Webservice: ResourceRequestable {
    enum Error: Swift.Error, Equatable {
        static func == (lhs: Error, rhs: Error) -> Bool {
            switch (lhs, rhs) {
            case (let .http(statusLhs, _), let .http(statusRhs, _)):
                return statusLhs == statusRhs
            case (.noData, .noData):
                return true
            case (.unknown, .unknown):
                return true
            default:
                return false
            }
        }

        case http(HTTPStatusCode, Swift.Error?)
        case noData(Swift.Error?)
        case unknown(Swift.Error?)
    }

    let baseURL: URL
    let session: URLSessionDataTaskLoader

    init(baseURL: URL, session: URLSessionDataTaskLoader = URLSession.shared) {
        self.baseURL = baseURL
        self.session = session
    }

    func load<Request: Encodable, Response: Decodable>(_ resource: Resource<Request, Response>,
                                                       completion: @escaping (Result<Response, Swift.Error>) -> Void) {

        do {
            let request = try URLRequest(resource: resource, baseURL: baseURL)

            session.dataTask(with: request) { data, response, error in
                if let response = response as? HTTPURLResponse {
                    if response.isSuccessful {
                        if let data = data {
                            completion(Result { try resource.decoder.decode(Response.self, from: data) })
                        } else {
                            completion(.failure(Error.noData(error)))
                        }
                    } else {
                        completion(.failure(Error.http(response.statusCode, error)))
                    }
                } else {
                    completion(.failure(Error.unknown(error)))
                }
                }.resume()
        } catch {
            completion(.failure(error))
        }
    }
}
