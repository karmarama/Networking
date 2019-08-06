import Foundation
@testable import Networking

final class RequestBehaviorMock: RequestBehavior {

    var callOrder = [String]()

    func modify(urlComponents: URLComponents) -> URLComponents {
        callOrder.append("\(#function)")
        return urlComponents
    }

    func modify(planned request: URLRequest) -> URLRequest {
        callOrder.append("\(#function)")
        return request
    }

    func before(sending request: URLRequest) {
        callOrder.append("\(#function)")
    }

    //swiftlint:disable:next large_tuple
    func modifyResponse(data: Data?, response: URLResponse?, error: Error?) -> (Data?, URLResponse?, Error?) {
        callOrder.append("\(#function)")
        return (data, response, error)
    }

    func after(completion result: Result<HTTPURLResponse, Error>) {
         callOrder.append("\(#function)")
    }
}
