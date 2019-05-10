import Foundation

public protocol ResourceRequestable {
    func load<Request: Encodable, Response: Decodable>(_ resource: Resource<Request, Response>,
                                                       completion: @escaping (Result<Response, Error>) -> Void)
}

public protocol URLSessionDataTaskLoader {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

public struct Webservice: ResourceRequestable {
    public enum Error: Swift.Error {
        case http(HTTP.StatusCode, Swift.Error?)
        case unknown(Swift.Error?)
    }

    private let baseURL: URL
    private let session: URLSessionDataTaskLoader
    private let defaultRequestBehaviour: RequestBehavior

    public init(baseURL: URL,
                session: URLSessionDataTaskLoader = URLSession.shared,
                defaultRequestBehaviour: RequestBehavior? = nil) {
        self.baseURL = baseURL
        self.session = session
        self.defaultRequestBehaviour = defaultRequestBehaviour ?? EmptyRequestBehavior()
    }

    public func load<Request: Encodable, Response: Decodable>
        (_ resource: Resource<Request, Response>,
         completion: @escaping (Result<Response, Swift.Error>) -> Void) {

        do {
            let request = resource.requestBehaviour.modify(planned: try URLRequest(resource: resource,
                                                                                   baseURL: baseURL))

            resource.requestBehaviour.before(sending: request)

            session.dataTask(with: request) { data, response, error in
                let (data, response, error) = resource.requestBehaviour.modifyResponse(data: data,
                                                                                       response: response,
                                                                                       error: error)
                if let response = response as? HTTPURLResponse {
                    if response.isSuccessful {
                        completion(Result { try resource.decoder.decode(Response.self,
                                                                        from: data,
                                                                        response: response)
                        })

                        resource.requestBehaviour.after(completion: response)

                        // Early return to prevent calling after(failure:) RequestBehavior
                        return
                    } else {
                        completion(.failure(Error.http(response.statusCode, error)))
                    }
                } else {
                    completion(.failure(Error.unknown(error)))
                }

                resource.requestBehaviour.after(failure: error)

            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
}
