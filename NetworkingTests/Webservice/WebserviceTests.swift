import XCTest
@testable import Networking

final class WebserviceTests: XCTestCase {
    private var webservice: Webservice!

    func testEmptyDataTaskSuccess() {
        let sessionMock = URLSessionDataTaskLoaderFake(data: nil,
                                                       response: HTTPURLResponse(url: URL.fake(),
                                                                                 statusCode: 200,
                                                                                 httpVersion: nil,
                                                                                 headerFields: nil),
                                                       error: nil)

        webservice = Webservice(baseURL: URL.fake(), session: sessionMock)

        let resource = Resource<Empty, Empty>(endpoint: "/", decoder: EmptyDecoder())

        let expect = expectation(description: "async")

        webservice.load(resource) { result in
            if case let .failure(error) = result {
                XCTFail("Expected Empty result, got \(error)")
            }
            expect.fulfill()
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func testHTTPFailingStatusCode() {
        let sessionMock = URLSessionDataTaskLoaderFake(data: nil,
                                                       response: HTTPURLResponse(url: URL.fake(),
                                                                                 statusCode: 400,
                                                                                 httpVersion: nil,
                                                                                 headerFields: nil),
                                                       error: nil)

        webservice = Webservice(baseURL: URL.fake(), session: sessionMock)

        let resource = Resource<Empty, Empty>(endpoint: "/", decoder: EmptyDecoder())

        let expect = expectation(description: "async")

        webservice.load(resource) { result in
            switch result {
            case .success:
                XCTFail("Expected an HTTP status error")
            case let .failure(error):
                if case let Webservice.Error.http(code, _) = error {
                    XCTAssertEqual(code, 400)
                } else {
                    XCTFail("Expected a Webservice.Error.http error type")
                }
            }
            expect.fulfill()
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func testNoHTTPURLResponseReceived() {
        let placeholderError = NSError(domain: "test", code: 1, userInfo: nil)
        let sessionMock = URLSessionDataTaskLoaderFake(data: nil,
                                                       response: URLResponse(url: URL.fake(),
                                                                             mimeType: nil,
                                                                             expectedContentLength: 0,
                                                                             textEncodingName: nil),
                                                       error: placeholderError)

        webservice = Webservice(baseURL: URL.fake(), session: sessionMock)

        let resource = Resource<Empty, Empty>(endpoint: "/", decoder: EmptyDecoder())

        let expect = expectation(description: "async")

        webservice.load(resource) { result in
            switch result {
            case .success:
                XCTFail("Expected an unknown error")
            case let .failure(error):
                if case let Webservice.Error.unknown(error as NSError) = error {
                    XCTAssertEqual(error, placeholderError)
                } else {
                    XCTFail("Expected a Webservice.Error.http error type")
                }
            }
            expect.fulfill()
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func testRequestBehaviorOrderForSuccess() {
        let sessionMock = URLSessionDataTaskLoaderFake(data: nil,
                                                       response: HTTPURLResponse(url: URL.fake(),
                                                                                 statusCode: 200,
                                                                                 httpVersion: nil,
                                                                                 headerFields: nil),
                                                       error: nil)
        let requestBehaviorMock = RequestBehaviorMock()

        webservice = Webservice(baseURL: URL.fake(),
                                session: sessionMock,
                                defaultRequestBehavior: requestBehaviorMock)

        let resource = Resource<Empty, Empty>(endpoint: "/", decoder: EmptyDecoder())

        let expect = expectation(description: "async")

        webservice.load(resource) { _ in
            expect.fulfill()
        }

        waitForExpectations(timeout: 0.1, handler: nil)

        XCTAssertEqual(requestBehaviorMock.callOrder.count, 5)
        XCTAssertEqual(requestBehaviorMock.callOrder, ["modify(urlComponents:)",
                                                       "modify(planned:)",
                                                       "before(sending:)",
                                                       "modifyResponse(data:response:error:)",
                                                       "after(completion:)"])
    }

    func testRequestBehaviorOrderForFailure() {
        let sessionMock = URLSessionDataTaskLoaderFake(data: nil,
                                                       response: HTTPURLResponse(url: URL.fake(),
                                                                                 statusCode: 400,
                                                                                 httpVersion: nil,
                                                                                 headerFields: nil),
                                                       error: nil)
        let requestBehaviorMock = RequestBehaviorMock()

        webservice = Webservice(baseURL: URL.fake(),
                                session: sessionMock,
                                defaultRequestBehavior: requestBehaviorMock)

        let resource = Resource<Empty, Empty>(endpoint: "/", decoder: EmptyDecoder())

        let expect = expectation(description: "async")

        webservice.load(resource) { _ in
            expect.fulfill()
        }

        waitForExpectations(timeout: 0.1, handler: nil)

        XCTAssertEqual(requestBehaviorMock.callOrder.count, 5)
        XCTAssertEqual(requestBehaviorMock.callOrder, ["modify(urlComponents:)",
                                                       "modify(planned:)",
                                                       "before(sending:)",
                                                       "modifyResponse(data:response:error:)",
                                                       "after(completion:)"])
    }

    func testWebserviceErrorWithInvalidResource() {
        let baseURL = URL(string: "a://@@")!
        let sessionMock = URLSessionDataTaskLoaderFake(data: nil,
                                                       response: HTTPURLResponse(url: baseURL,
                                                                                 statusCode: 400,
                                                                                 httpVersion: nil,
                                                                                 headerFields: nil),
                                                       error: nil)
        let requestBehaviorMock = RequestBehaviorMock()

        webservice = Webservice(baseURL: baseURL,
                                session: sessionMock,
                                defaultRequestBehavior: requestBehaviorMock)

        let resource = Resource<Empty, Empty>(endpoint: "/", decoder: EmptyDecoder())

        let expect = expectation(description: "async")

        webservice.load(resource) { result in
            guard case let .failure(error) = result,
                let requestError = error as? URLRequest.Error else {
                XCTFail("Expected a URLRequest error")
                return
            }

            XCTAssertTrue(requestError == URLRequest.Error.malformedBaseURL)
            expect.fulfill()
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
