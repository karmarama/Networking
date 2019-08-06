import XCTest
@testable import Networking

final class BackgroundDecoderValidator: ResourceDecoder {
    public func decode<Value: Decodable>(_ type: Value.Type,
                                         from data: Data?,
                                         response: HTTPURLResponse) throws -> Value {
        XCTAssertNotEqual(Thread.current, Thread.main)
        return Empty() as! Value //swiftlint:disable:this force_cast
    }
}

final class RequestBehaviorThreadValidator: RequestBehavior {
    let queue: OperationQueue

    init(queue: OperationQueue) {
        self.queue = queue
    }

    func modify(urlComponents: URLComponents) -> URLComponents {
        XCTAssertEqual(OperationQueue.current, queue)
        return urlComponents
    }

    func modify(planned request: URLRequest) -> URLRequest {
        XCTAssertEqual(OperationQueue.current, queue)
        return request
    }

    func before(sending request: URLRequest) {
        XCTAssertEqual(OperationQueue.current, queue)
    }

    //swiftlint:disable:next large_tuple
    func modifyResponse(data: Data?, response: URLResponse?, error: Error?) -> (Data?, URLResponse?, Error?) {
        XCTAssertEqual(OperationQueue.current, queue)
        return (data, response, error)
    }

    func after(completion result: Result<HTTPURLResponse, Error>) {
        XCTAssertEqual(OperationQueue.current, queue)
    }
}
