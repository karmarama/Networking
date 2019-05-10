import Foundation

public protocol ResourceRequestable {
    func load<Request: Encodable, Response: Decodable>(_ resource: Resource<Request, Response>,
                                                       completion: @escaping (Result<Response, Error>) -> Void)
}

public protocol URLSessionDataTaskLoader {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

public typealias HTTPStatusCode = Int

public struct Webservice: ResourceRequestable {
    public enum Error: Swift.Error {
        case http(HTTPStatusCode, Swift.Error?)
        case unknown(Swift.Error?)
    }

    private let baseURL: URL
    private let session: URLSessionDataTaskLoader

    public init(baseURL: URL, session: URLSessionDataTaskLoader = URLSession.shared) {
        self.baseURL = baseURL
        self.session = session
    }

    public func load<Request: Encodable, Response: Decodable>
        (_ resource: Resource<Request, Response>,
         completion: @escaping (Result<Response, Swift.Error>) -> Void) {

        do {
            let request = try URLRequest(resource: resource, baseURL: baseURL)

            session.dataTask(with: request) { data, response, error in
                if let response = response as? HTTPURLResponse {
                    if response.isSuccessful {
                        completion(Result { try resource.decoder.decode(Response.self,
                                                                        from: data,
                                                                        response: response)
                        })
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
