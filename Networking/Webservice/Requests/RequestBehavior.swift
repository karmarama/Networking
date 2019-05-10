import Foundation

public protocol RequestBehavior {
    func modify(urlComponents: URLComponents) -> URLComponents
    func modify(planned request: URLRequest) -> URLRequest
    func before(sending request: URLRequest)

    func after(completion response: URLResponse?)
    func after(failure: Error?)
}

public extension RequestBehavior {
    func modify(urlComponents: URLComponents) -> URLComponents { return urlComponents }
    func modify(planned request: URLRequest) -> URLRequest { return request }
    func before(sending: URLRequest) { }

    func after(completion: URLResponse?) { }
    func after(failure: Error?) { }

    func adding(_ behavior: RequestBehavior) -> RequestBehavior {
        return CompoundRequestBehavior(behaviors: [self, behavior])
    }
}

struct EmptyRequestBehavior: RequestBehavior {}

private struct CompoundRequestBehavior: RequestBehavior {
    let behaviors: [RequestBehavior]

    init(behaviors: [RequestBehavior]) {
        self.behaviors = behaviors
    }

    func modify(planned request: URLRequest) -> URLRequest {
        var request = request

        behaviors.forEach {
            request = $0.modify(planned: request)
        }

        return request
    }

    func before(sending request: URLRequest) {
        behaviors.forEach {
            $0.before(sending: request)
        }
    }

    func after(completion response: URLResponse?) {
        behaviors.forEach {
            $0.after(completion: response)
        }
    }

    func after(failure: Error?) {
        behaviors.forEach {
            $0.after(failure: failure)
        }
    }
}
