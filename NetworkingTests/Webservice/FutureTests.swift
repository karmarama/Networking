import Combine
import XCTest
@testable import Networking

@available(iOS 13.0, *)
final class FutureTests: XCTestCase {
    private var webservice: ResourceRequestable!

    private let emptyDecoder = EmptyDecoder()

    func testFutureSuccess() {
        let sessionMock = URLSessionDataTaskLoaderFake(data: nil,
                                                       response: HTTPURLResponse(url: URL.fake(),
                                                                                 statusCode: 200,
                                                                                 httpVersion: nil,
                                                                                 headerFields: nil),
                                                       error: nil)

        webservice = Webservice(baseURL: URL.fake(), session: sessionMock)

        let resource = Resource<Networking.Empty, Networking.Empty>(endpoint: "/", decoder: emptyDecoder)

        let expectedCompletion = expectation(description: "expectedCompletion")
        let expectedValue = expectation(description: "expectedValue")

        webservice
            .future(for: resource)
            .receive(on: DispatchQueue.main)
            .subscribe(Subscribers.Sink(
                        receiveCompletion: { completion in
                            if case let .failure(error) = completion {
                                XCTFail("Expected Empty result, got \(error)")
                            }
                            expectedCompletion.fulfill()
                        },
                        receiveValue: { _ in
                            XCTAssertTrue(Thread.isMainThread)
                            expectedValue.fulfill()
                        }))

        waitForExpectations(timeout: 0.5, handler: nil)
    }

    func testFutureFailure() {
        let sessionMock = URLSessionDataTaskLoaderFake(data: nil,
                                                       response: HTTPURLResponse(url: URL.fake(),
                                                                                 statusCode: 400,
                                                                                 httpVersion: nil,
                                                                                 headerFields: nil),
                                                       error: nil)

        webservice = Webservice(baseURL: URL.fake(), session: sessionMock)

        let resource = Resource<Networking.Empty, Networking.Empty>(endpoint: "/", decoder: emptyDecoder)

        let expectedError = expectation(description: "expectedError")

        webservice
            .future(for: resource)
            .subscribe(Subscribers.Sink(
                        receiveCompletion: { completion in
                            XCTAssertFalse(Thread.isMainThread)
                            switch completion {
                            case .finished:
                                XCTFail("Expected an HTTP status error")
                            case let .failure(error):
                                if case let Webservice.Error.http(code, _, _) = error {
                                    XCTAssertEqual(code, 400)
                                    expectedError.fulfill()
                                } else {
                                    XCTFail("Expected a Webservice.Error.http error type")
                                }
                            }
                        }, receiveValue: { _ in
                        }))

        waitForExpectations(timeout: 0.5, handler: nil)
    }

    func testFutureMainQueue() {
        let sessionMock = URLSessionDataTaskLoaderFake(data: nil,
                                                       response: HTTPURLResponse(url: URL.fake(),
                                                                                 statusCode: 200,
                                                                                 httpVersion: nil,
                                                                                 headerFields: nil),
                                                       error: nil)

        webservice = Webservice(baseURL: URL.fake(), session: sessionMock)

        let resource = Resource<Networking.Empty, Networking.Empty>(endpoint: "/", decoder: emptyDecoder)

        let expectedCompletion = expectation(description: "expectedCompletion")
        let expectedValue = expectation(description: "expectedValue")

        webservice
            .future(for: resource, queue: .main)
            .subscribe(Subscribers.Sink(
                        receiveCompletion: { completion in
                            if case let .failure(error) = completion {
                                XCTFail("Expected Empty result, got \(error)")
                            }
                            expectedCompletion.fulfill()
                        },
                        receiveValue: { _ in
                            XCTAssertTrue(Thread.isMainThread)
                            expectedValue.fulfill()
                        }))

        waitForExpectations(timeout: 0.5, handler: nil)
    }
}
