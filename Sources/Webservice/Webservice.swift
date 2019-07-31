import Foundation

public protocol ResourceRequestable {
    /// Load the resource
    ///
    /// - Parameters:
    ///   - completion: Note: always called on the main thread
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
    private let defaultRequestBehavior: RequestBehavior

    public init(baseURL: URL,
                session: URLSessionDataTaskLoader = URLSession.shared,
                defaultRequestBehavior: RequestBehavior? = nil) {
        self.baseURL = baseURL
        self.session = session
        self.defaultRequestBehavior = defaultRequestBehavior ?? EmptyRequestBehavior()
    }

    public func load<Request: Encodable, Response: Decodable>
        (_ resource: Resource<Request, Response>,
         completion: @escaping (Result<Response, Swift.Error>) -> Void) {

        do {
            let requestBehavior = defaultRequestBehavior.and(resource.requestBehavior)

            let request = requestBehavior.modify(planned: try URLRequest(resource: resource,
                                                                         defaultRequestBehavior: defaultRequestBehavior,
                                                                         baseURL: baseURL))

            DispatchQueue.main.async {
                requestBehavior.before(sending: request)
            }

            session.dataTask(with: request) { data, response, error in
                let (data, response, error) = requestBehavior.modifyResponse(data: data,
                                                                             response: response,
                                                                             error: error)
                if let response = response as? HTTPURLResponse {
                    if response.isSuccessful {
                        let result = Result { try resource.decoder.decode(Response.self,
                                                                          from: data,
                                                                          response: response)
                        }

                        DispatchQueue.main.async {
                            completion(result)
                            requestBehavior.after(completion: .success(response))
                        }

                        // Early return to prevent calling after(completion:) RequestBehavior for failure
                        return
                    } else {
                        DispatchQueue.main.async {
                            completion(.failure(Error.http(response.statusCode, error)))
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(Error.unknown(error))) // should this be a system error not unknown?
                    }
                }

                DispatchQueue.main.async {
                    requestBehavior.after(completion: .failure(error ?? Error.unknown(error)))
                }
            }.resume()
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
}
