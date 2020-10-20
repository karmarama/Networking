import Combine
import Foundation

@available(iOS 13.0, *)
extension ResourceRequestable {

    func future<Request, Response>(for resource: Resource<Request, Response>,
                                   queue: OperationQueue = .main) -> AnyPublisher<Response, Swift.Error> {
        Future { completion in
            load(resource, queue: queue, completion: completion)
        }.receive(on: queue)
        .eraseToAnyPublisher()
    }
}
