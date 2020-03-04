import XCTest
@testable import Networking

class RequestBehaviorSimpleTests: XCTestCase {
    let emptyDecoder = EmptyDecoder()

    // MARK: - Modify URL components
    func testModifyURLComponentsCalled() throws {
        let resource = Resource<Empty, Empty>(endpoint: "/", decoder: emptyDecoder)
        let requestBehaviorMock = RequestBehaviorMock()

        _ = try URLRequest(resource: resource,
                           requestBehavior: requestBehaviorMock,
                           baseURL: URL(fileURLWithPath: "/"))

        XCTAssertEqual(requestBehaviorMock.callOrder, ["modify(urlComponents:)"])
    }

    func testModifyURLComponentsCalledNested() throws {
        let resource = Resource<Empty, Empty>(endpoint: "/", decoder: emptyDecoder)
        let firstRequestBehaviorMock = RequestBehaviorMock()
        let secondRequestBehaviorMock = RequestBehaviorMock()
        let nestedRequestBehaviorMock = firstRequestBehaviorMock.and(secondRequestBehaviorMock)

        _ = try URLRequest(resource: resource,
                           requestBehavior: nestedRequestBehaviorMock,
                           baseURL: URL(fileURLWithPath: "/"))

        XCTAssertEqual(firstRequestBehaviorMock.callOrder, ["modify(urlComponents:)"])
        XCTAssertEqual(secondRequestBehaviorMock.callOrder, ["modify(urlComponents:)"])
    }

    func testModifyURLComponentsNestedPayload() throws {
        let resource = Resource<Empty, Empty>(endpoint: "", decoder: emptyDecoder)
        let firstRequestBehaviorMock = ModifyURLComponentsRequestBehaviorMock()
        firstRequestBehaviorMock.urlComponents = URLComponents(string: "https://a.b.c/path")
        let secondRequestBehaviorMock = ModifyURLComponentsRequestBehaviorMock()
        secondRequestBehaviorMock.urlComponents = URLComponents(string: "https://x.y.z/path2")
        let nestedRequestBehaviorMock = firstRequestBehaviorMock.and(secondRequestBehaviorMock)

        let request = try URLRequest(resource: resource,
                                     requestBehavior: nestedRequestBehaviorMock,
                                     baseURL: URL(fileURLWithPath: "/"))

        XCTAssertEqual(firstRequestBehaviorMock.urlComponents?.url?.absoluteString, "file:///")
        XCTAssertEqual(secondRequestBehaviorMock.urlComponents?.url?.absoluteString, "https://a.b.c/path")
        XCTAssertEqual(request.url?.absoluteString, "https://x.y.z/path2")
    }
}

final class RequestBehaviorTests: XCTestCase {
    let emptyDecoder = EmptyDecoder()
    let sessionMock = URLSessionDataTaskLoaderFake(data: nil,
                                                   response: HTTPURLResponse(url: URL.fake(),
                                                                             statusCode: 200,
                                                                             httpVersion: nil,
                                                                             headerFields: nil),
                                                   error: nil)

    private var expect: XCTestExpectation!

    override func setUp() {
        super.setUp()
        expect = expectation(description: "async")
    }
}

// MARK: - Modify planned request
extension RequestBehaviorTests {
    func testModifyPlannedRequestCalled() {
        let requestBehaviorMock = RequestBehaviorMock()

        let webservice = Webservice(baseURL: URL.fake(),
                                    session: sessionMock,
                                    defaultRequestBehavior: requestBehaviorMock)

        let resource = Resource<Empty, Empty>(endpoint: "/", decoder: emptyDecoder)

        webservice.load(resource) { _ in
            self.expect.fulfill()
        }

        waitForExpectations(timeout: 0.5, handler: nil)

        XCTAssertTrue(requestBehaviorMock.callOrder.contains("modify(planned:)"))
    }

    func testModifyPlannedRequestCalledNested() {
        let firstRequestBehaviorMock = RequestBehaviorMock()
        let secondRequestBehaviorMock = RequestBehaviorMock()
        let nestedRequestBehaviorMock = firstRequestBehaviorMock.and(secondRequestBehaviorMock)
        let thirdRequestBehaviorMock = RequestBehaviorMock()

        let webservice = Webservice(baseURL: URL.fake(),
                                    session: sessionMock,
                                    defaultRequestBehavior: nestedRequestBehaviorMock)

        let resource = Resource<Empty, Empty>(endpoint: "/",
                                              requestBehavior: thirdRequestBehaviorMock,
                                              decoder: emptyDecoder)

        webservice.load(resource) { _ in
            self.expect.fulfill()
        }

        waitForExpectations(timeout: 0.5, handler: nil)

        XCTAssertTrue(firstRequestBehaviorMock.callOrder.contains("modify(planned:)"))
        XCTAssertTrue(secondRequestBehaviorMock.callOrder.contains("modify(planned:)"))
        XCTAssertTrue(thirdRequestBehaviorMock.callOrder.contains("modify(planned:)"))
    }

    func testModifyPlannedRequestNestedPayload() {
        let sessionMock = URLSessionDataTaskLoaderRequestFake()
        let firstRequestBehaviorMock = ModifyPlannedRequestBehaviorMock()
        firstRequestBehaviorMock.request = URLRequest(url: URL(fileURLWithPath: "//a"))
        let secondRequestBehaviorMock = ModifyPlannedRequestBehaviorMock()
        secondRequestBehaviorMock.request = URLRequest(url: URL(string: "https://a.b.c/z?d=e")!)
        let nestedRequestBehaviorMock = firstRequestBehaviorMock.and(secondRequestBehaviorMock)
        let thirdRequestBehaviorMock = ModifyPlannedRequestBehaviorMock()
        thirdRequestBehaviorMock.request = URLRequest(url: URL(fileURLWithPath: "/c"))

        let webservice = Webservice(baseURL: URL.fake(),
                                    session: sessionMock,
                                    defaultRequestBehavior: nestedRequestBehaviorMock)

        let resource = Resource<Empty, Empty>(endpoint: "/",
                                              requestBehavior: thirdRequestBehaviorMock,
                                              decoder: emptyDecoder)

        webservice.load(resource) { _ in
            self.expect.fulfill()
        }

        waitForExpectations(timeout: 0.5, handler: nil)

        XCTAssertEqual(firstRequestBehaviorMock.request?.url?.absoluteString, "https://www.karmarama.com/")
        XCTAssertEqual(secondRequestBehaviorMock.request?.url?.absoluteString, "file:////a")
        XCTAssertEqual(thirdRequestBehaviorMock.request?.url?.absoluteString, "https://a.b.c/z?d=e")
        XCTAssertEqual(sessionMock.request?.url?.absoluteString, "file:///c")
    }
}

// MARK: - Before sending request
extension RequestBehaviorTests {
    func testBeforeSendingRequestCalled() {
        let requestBehaviorMock = RequestBehaviorMock()

        let webservice = Webservice(baseURL: URL.fake(),
                                    session: sessionMock,
                                    defaultRequestBehavior: requestBehaviorMock)

        let resource = Resource<Empty, Empty>(endpoint: "/", decoder: emptyDecoder)

        webservice.load(resource) { _ in
            self.expect.fulfill()
        }

        waitForExpectations(timeout: 0.5, handler: nil)

        XCTAssertTrue(requestBehaviorMock.callOrder.contains("before(sending:)"))
    }

    func testBeforeSendingRequestCalledNested() {
        let firstRequestBehaviorMock = RequestBehaviorMock()
        let secondRequestBehaviorMock = RequestBehaviorMock()
        let nestedRequestBehaviorMock = firstRequestBehaviorMock.and(secondRequestBehaviorMock)
        let thirdRequestBehaviorMock = RequestBehaviorMock()

        let webservice = Webservice(baseURL: URL.fake(),
                                    session: sessionMock,
                                    defaultRequestBehavior: nestedRequestBehaviorMock)

        let resource = Resource<Empty, Empty>(endpoint: "/",
                                              requestBehavior: thirdRequestBehaviorMock,
                                              decoder: emptyDecoder)

        webservice.load(resource) { _ in
            self.expect.fulfill()
        }

        waitForExpectations(timeout: 0.5, handler: nil)

        XCTAssertTrue(firstRequestBehaviorMock.callOrder.contains("before(sending:)"))
        XCTAssertTrue(secondRequestBehaviorMock.callOrder.contains("before(sending:)"))
        XCTAssertTrue(thirdRequestBehaviorMock.callOrder.contains("before(sending:)"))
    }
}

// MARK: - Modify response
extension RequestBehaviorTests {
    func testModifyResponseCalled() {
        let requestBehaviorMock = RequestBehaviorMock()

        let webservice = Webservice(baseURL: URL.fake(),
                                    session: sessionMock,
                                    defaultRequestBehavior: requestBehaviorMock)

        let resource = Resource<Empty, Empty>(endpoint: "/", decoder: emptyDecoder)

        webservice.load(resource) { _ in
            self.expect.fulfill()
        }

        waitForExpectations(timeout: 0.5, handler: nil)

        XCTAssertTrue(requestBehaviorMock.callOrder.contains("modifyResponse(data:response:error:)"))
    }

    func testModifyResponseCalledNested() {
        let firstRequestBehaviorMock = RequestBehaviorMock()
        let secondRequestBehaviorMock = RequestBehaviorMock()
        let nestedRequestBehaviorMock = firstRequestBehaviorMock.and(secondRequestBehaviorMock)
        let thirdRequestBehaviorMock = RequestBehaviorMock()

        let webservice = Webservice(baseURL: URL.fake(),
                                    session: sessionMock,
                                    defaultRequestBehavior: nestedRequestBehaviorMock)

        let resource = Resource<Empty, Empty>(endpoint: "/",
                                              requestBehavior: thirdRequestBehaviorMock,
                                              decoder: emptyDecoder)

        webservice.load(resource) { _ in
            self.expect.fulfill()
        }

        waitForExpectations(timeout: 0.5, handler: nil)

        XCTAssertTrue(firstRequestBehaviorMock.callOrder.contains("modifyResponse(data:response:error:)"))
        XCTAssertTrue(secondRequestBehaviorMock.callOrder.contains("modifyResponse(data:response:error:)"))
        XCTAssertTrue(thirdRequestBehaviorMock.callOrder.contains("modifyResponse(data:response:error:)"))
    }

    //swiftlint:disable:next function_body_length
    func testModifyResponseNestedPayloadSuccess() {
        let firstRequestBehaviorMock = ModifyResponseBehaviorMock()
        firstRequestBehaviorMock.data = "data".data(using: .utf8)!
        firstRequestBehaviorMock.response = HTTPURLResponse(url: URL.fake().appendingPathComponent("a"),
                                                            statusCode: 201,
                                                            httpVersion: nil,
                                                            headerFields: nil)
        let secondRequestBehaviorMock = ModifyResponseBehaviorMock()
        secondRequestBehaviorMock.data = "data2".data(using: .utf8)!
        secondRequestBehaviorMock.response = HTTPURLResponse(url: URL.fake().appendingPathComponent("b"),
                                                             statusCode: 301,
                                                             httpVersion: nil,
                                                             headerFields: nil)
        let nestedRequestBehaviorMock = firstRequestBehaviorMock.and(secondRequestBehaviorMock)
        let thirdRequestBehaviorMock = ModifyResponseBehaviorMock()
        thirdRequestBehaviorMock.data = "data3".data(using: .utf8)!
        thirdRequestBehaviorMock.response = HTTPURLResponse(url: URL.fake().appendingPathComponent("c"),
                                                            statusCode: 200,
                                                            httpVersion: nil,
                                                            headerFields: nil)

        let webservice = Webservice(baseURL: URL.fake(),
                                    session: sessionMock,
                                    defaultRequestBehavior: nestedRequestBehaviorMock)
        let decoder = EmptyDataResponseDecoder()

        let resource = Resource<Empty, Empty>(endpoint: "/",
                                              requestBehavior: thirdRequestBehaviorMock,
                                              decoder: decoder)

        var data: Data?
        var response: URLResponse?

        webservice.load(resource) { result in
            guard case .success = result else {
                XCTFail("Expected a success response")
                return
            }

            data = decoder.data
            response = decoder.response
            self.expect.fulfill()
        }

        waitForExpectations(timeout: 0.5, handler: nil)

        XCTAssertNil(firstRequestBehaviorMock.data)
        XCTAssertEqual(secondRequestBehaviorMock.data, "data".data(using: .utf8)!)
        XCTAssertEqual(thirdRequestBehaviorMock.data, "data2".data(using: .utf8)!)
        XCTAssertEqual(data, "data3".data(using: .utf8)!)

        XCTAssertEqual((firstRequestBehaviorMock.response as? HTTPURLResponse)?.statusCode, 200)
        XCTAssertEqual((secondRequestBehaviorMock.response as? HTTPURLResponse)?.statusCode, 201)
        XCTAssertEqual((thirdRequestBehaviorMock.response as? HTTPURLResponse)?.statusCode, 301)
        XCTAssertEqual((response as? HTTPURLResponse)?.statusCode, 200)

        XCTAssertEqual((firstRequestBehaviorMock.response as? HTTPURLResponse)?.url?.path, "")
        XCTAssertEqual((secondRequestBehaviorMock.response as? HTTPURLResponse)?.url?.path, "/a")
        XCTAssertEqual((thirdRequestBehaviorMock.response as? HTTPURLResponse)?.url?.path, "/b")
        XCTAssertEqual((response as? HTTPURLResponse)?.url?.path, "/c")
    }

    func testModifyResponseNestedPayloadFailure() {
        let firstRequestBehaviorMock = ModifyResponseBehaviorMock()
        firstRequestBehaviorMock.error = NSError(domain: "", code: 5000, userInfo: nil)
        firstRequestBehaviorMock.response = HTTPURLResponse(url: URL.fake(), statusCode: 500,
                                                            httpVersion: nil, headerFields: nil)
        let secondRequestBehaviorMock = ModifyResponseBehaviorMock()
        secondRequestBehaviorMock.error = NSError(domain: "", code: 5010, userInfo: nil)
        secondRequestBehaviorMock.response = HTTPURLResponse(url: URL.fake(), statusCode: 501,
                                                             httpVersion: nil, headerFields: nil)
        let nestedRequestBehaviorMock = firstRequestBehaviorMock.and(secondRequestBehaviorMock)
        let thirdRequestBehaviorMock = ModifyResponseBehaviorMock()
        thirdRequestBehaviorMock.error = NSError(domain: "", code: 5020, userInfo: nil)
        thirdRequestBehaviorMock.response = HTTPURLResponse(url: URL.fake(), statusCode: 502,
                                                            httpVersion: nil, headerFields: nil)

        let webservice = Webservice(baseURL: URL.fake(),
                                    session: sessionMock,
                                    defaultRequestBehavior: nestedRequestBehaviorMock)
        let decoder = EmptyDataResponseDecoder()

        let resource = Resource<Empty, Empty>(endpoint: "/",
                                              requestBehavior: thirdRequestBehaviorMock,
                                              decoder: decoder)

        var error: Error! = nil

        webservice.load(resource) { result in
            guard case let .failure(resultError) = result else {
                XCTFail("Expected a failure response")
                return
            }

            error = resultError
            self.expect.fulfill()
        }

        waitForExpectations(timeout: 0.5, handler: nil)

        guard case let Webservice.Error.http(httpCode, httpUnderlying, _) = error! else {
            XCTFail("Expected a webservice http error")
            return
        }

        XCTAssertEqual(httpCode, 502)

        XCTAssertNil(firstRequestBehaviorMock.error)
        XCTAssertEqual((secondRequestBehaviorMock.error as NSError?)?.code, 5000)
        XCTAssertEqual((thirdRequestBehaviorMock.error as NSError?)?.code, 5010)
        XCTAssertEqual((httpUnderlying as NSError?)?.code, 5020)

        XCTAssertEqual((firstRequestBehaviorMock.response as? HTTPURLResponse)?.statusCode, 200)
        XCTAssertEqual((secondRequestBehaviorMock.response as? HTTPURLResponse)?.statusCode, 500)
        XCTAssertEqual((thirdRequestBehaviorMock.response as? HTTPURLResponse)?.statusCode, 501)
    }
}

// MARK: - After completion result
extension RequestBehaviorTests {
    func testAfterCompletionResultCalled() {
        let requestBehaviorMock = RequestBehaviorMock()

        let webservice = Webservice(baseURL: URL.fake(),
                                    session: sessionMock,
                                    defaultRequestBehavior: requestBehaviorMock)

        let resource = Resource<Empty, Empty>(endpoint: "/", decoder: emptyDecoder)

        webservice.load(resource) { _ in
            self.expect.fulfill()
        }

        waitForExpectations(timeout: 0.5, handler: nil)

        XCTAssertTrue(requestBehaviorMock.callOrder.contains("after(completion:)"))
    }

    func testAfterCompletionResultCalledNested() {
        let firstRequestBehaviorMock = RequestBehaviorMock()
        let secondRequestBehaviorMock = RequestBehaviorMock()
        let nestedRequestBehaviorMock = firstRequestBehaviorMock.and(secondRequestBehaviorMock)
        let thirdRequestBehaviorMock = RequestBehaviorMock()

        let webservice = Webservice(baseURL: URL.fake(),
                                    session: sessionMock,
                                    defaultRequestBehavior: nestedRequestBehaviorMock)

        let resource = Resource<Empty, Empty>(endpoint: "/",
                                              requestBehavior: thirdRequestBehaviorMock,
                                              decoder: emptyDecoder)

        webservice.load(resource) { _ in
            self.expect.fulfill()
        }

        waitForExpectations(timeout: 0.5, handler: nil)

        XCTAssertTrue(firstRequestBehaviorMock.callOrder.contains("after(completion:)"))
        XCTAssertTrue(secondRequestBehaviorMock.callOrder.contains("after(completion:)"))
        XCTAssertTrue(thirdRequestBehaviorMock.callOrder.contains("after(completion:)"))
    }
}
