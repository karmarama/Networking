import Combine
import Foundation

@available(iOS 13.0, *)
extension ResourceRequestable {

    func future<Request, Response>(for resource: Resource<Request, Response>) -> AnyPublisher<Response, Swift.Error> {
        return Future { completion in
            load(resource, completion: completion)
        }.eraseToAnyPublisher()
    }
}
