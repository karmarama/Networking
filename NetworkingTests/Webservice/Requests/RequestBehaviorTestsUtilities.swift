import XCTest
@testable import Networking

final class URLSessionDataTaskLoaderRequestFake: URLSessionDataTaskLoader {
    final class URLSessionDataTaskMock: URLSessionDataTask {
        override func resume() {
            return
        }
    }

    var request: URLRequest?

    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.request = request
        completionHandler(nil, nil, nil)
        return URLSessionDataTaskMock()
    }
}

final class ModifyURLComponentsRequestBehaviorMock: RequestBehavior {
    var urlComponents: URLComponents?

    func modify(urlComponents: URLComponents) -> URLComponents {
        let returnComponents = self.urlComponents ?? urlComponents

        self.urlComponents = urlComponents

        return returnComponents
    }
}

final class ModifyPlannedRequestBehaviorMock: RequestBehavior {
    var request: URLRequest?

    func modify(planned request: URLRequest) -> URLRequest {
        let returnRequest = self.request ?? request

        self.request = request

        return returnRequest
    }
}

final class ModifyResponseBehaviorMock: RequestBehavior {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    //swiftlint:disable:next large_tuple
    func modifyResponse(data: Data?, response: URLResponse?, error: Error?) -> (Data?, URLResponse?, Error?) {
        let returnData = self.data ?? data
        let returnResponse = self.response ?? response
        let returnError = self.error ?? error

        self.data = data
        self.response = response
        self.error = error

        return (returnData, returnResponse, returnError)
    }
}

final class EmptyDataResponseDecoder: ResourceDecoder {
    var data: Data?
    var response: HTTPURLResponse?

    func decode<Value: Decodable>(_ type: Value.Type,
                                  from data: Data?,
                                  response: HTTPURLResponse) throws -> Value {
        self.data = data
        self.response = response
        return Empty() as! Value //swiftlint:disable:this force_cast
    }
}
