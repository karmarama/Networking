import Foundation

public protocol ResourceRequestable {
    func load<Request: Encodable, Response: Decodable>(_ resource: Resource<Request, Response>,
                                                       queue: OperationQueue,
                                                       completion: @escaping (Result<Response, Error>) -> Void)
}

public extension ResourceRequestable {
    func load<Request: Encodable, Response: Decodable>(_ resource: Resource<Request, Response>,
                                                       completion: @escaping (Result<Response, Error>) -> Void) {
        load(resource,
             queue: .main,
             completion: completion)
    }
}

public protocol URLSessionDataTaskLoader {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

public struct Webservice: ResourceRequestable {
    public enum Error: Swift.Error {
        case http(HTTP.StatusCode, Swift.Error?, Data?)
        case system(Swift.Error?)
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

        let requestBehavior = self.defaultRequestBehavior.and(resource.requestBehavior)

        queue.addOperation {
            do {
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

                                    let result = Result {
                                        try resource.decoder.decode(Response.self, from: data, response: response)
                                    }

                                    queue.addOperation {
                                        completion(result)
                                        requestBehavior.after(completion: .success(response))
                                    }
                            } else {
                                completion(.failure(Error.http(response.statusCode, error, data)))
                                requestBehavior.after(completion:
                                    .failure(Error.http(response.statusCode, error, data)))
                            }
                        } else {
                            completion(.failure(Error.system(error)))
                            requestBehavior.after(completion: .failure(Error.system(error)))
                        }
                    }
                }.resume()
            } catch {
                completion(.failure(error))
                requestBehavior.after(completion: .failure(error))
            }
        }
    }
}
