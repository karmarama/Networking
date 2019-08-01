import Foundation

public protocol ResourceRequestable {
    func load<Request: Encodable, Response: Decodable>(_ resource: Resource<Request, Response>,
                                                       queue: OperationQueue,
                                                       completion: @escaping (Result<Response, Error>) -> Void)
}

extension ResourceRequestable {
    func load<Request: Encodable, Response: Decodable>(_ resource: Resource<Request, Response>,
                                                       completion: @escaping (Result<Response, Error>) -> Void) {
        load(resource,
             queue: OperationQueue.main,
             completion: completion)
    }
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
         queue: OperationQueue,
         completion: @escaping (Result<Response, Swift.Error>) -> Void) {

        queue.addOperation {
            do {
                let requestBehavior = self.defaultRequestBehavior.and(resource.requestBehavior)

                let request = requestBehavior.modify(planned: try URLRequest(resource: resource,
                                                                             requestBehavior: requestBehavior,
                                                                             baseURL: self.baseURL))

                requestBehavior.before(sending: request)

                self.session.dataTask(with: request) { data, response, error in
                    queue.addOperation {
                        let (data, response, error) = requestBehavior.modifyResponse(data: data,
                                                                                     response: response,
                                                                                     error: error)
                        if let response = response as? HTTPURLResponse {
                            if response.isSuccessful {
                                completion(Result { try resource.decoder.decode(Response.self,
                                                                                from: data,
                                                                                response: response)
                                })
                                requestBehavior.after(completion: .success(response))

                                // Early return to prevent calling after(completion:) RequestBehavior for failure
                                return
                            } else {
                                completion(.failure(Error.http(response.statusCode, error)))
                            }
                        } else {
                            completion(.failure(Error.unknown(error))) // should this be a system error not unknown?
                        }

                        requestBehavior.after(completion: .failure(error ?? Error.unknown(error)))
                    }
                }.resume()
            } catch {
                completion(.failure(error))
            }
        }
    }
}
