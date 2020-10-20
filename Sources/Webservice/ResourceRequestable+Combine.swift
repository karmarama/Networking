import Combine
import Foundation

@available(iOS 13.0, *)
extension ResourceRequestable {

    /**
     Creates a future that completes when the load(resource:, queue:) completes.
     - Parameter resource: Wrapper around a network request
     - Parameter queue: Operation queue where the decoding and behaviours occur
     - Note: When using the default queue,
     use .receive(on: .main) on your publisher to ensure the subscription runs in the main queue
     */
    func future<Request, Response>(
        for resource: Resource<Request, Response>,
        queue: OperationQueue = OperationQueue()) -> Future<Response, Error> {
        Future { completion in
            load(resource, queue: queue, completion: completion)
        }
    }
}
