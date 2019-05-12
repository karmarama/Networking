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
//
//    func testHTTPErrorDataTaskFailureNoError() {
//        let sessionMock = URLSessionDataTaskLoaderFake(data: nil,
//                                                       response: HTTPURLResponse.response(code: 400),
//                                                       error: nil)
//        let sut = Webservice(baseURL: URL.dummy(), session: sessionMock)
//
//        let resource = Empty.fake()
//
//        sut.load(resource) { result in
//            switch result {
//            case .success(let empty):
//                XCTFail("Expected failure result, got \(empty)")
//            case .failure(let error):
//                guard let webserviceError = error as? WebserviceError else {
//                    XCTFail()
//                    return
//                }
//
//                XCTAssertEqual(WebserviceError.http(400, nil), webserviceError,
//                               "Expected 400, got \(webserviceError)")
//            }
//        }
//    }
//
//    func testNoDataTaskFailure() {
//        let sessionMock = URLSessionDataTaskLoaderFake(data: nil,
//                                                       response: HTTPURLResponse.response(code: 200),
//                                                       error: nil)
//        let sut = Webservice(baseURL: URL.dummy(), session: sessionMock)
//
//        let resource = Empty.fake()
//
//        sut.load(resource) { result in
//            switch result {
//            case .success(let empty):
//                XCTFail("Expected failure result, got \(empty)")
//            case .failure(let error):
//                guard let webserviceError = error as? WebserviceError else {
//                    XCTFail()
//                    return
//                }
//
//                XCTAssertEqual(WebserviceError.noData(nil), webserviceError,
//                               "Expect noData, got \(webserviceError)")
//            }
//        }
//    }
//
//    func testUnknownErrorTaskFailure() {
//        let sessionMock = URLSessionDataTaskLoaderFake(data: nil,
//                                                       response: nil,
//                                                       error: nil)
//        let sut = Webservice(baseURL: URL.dummy(), session: sessionMock)
//
//        let resource = Empty.fake()
//
//        sut.load(resource) { result in
//            switch result {
//            case .success(let empty):
//                XCTFail("Expected failure result, got \(empty)")
//            case .failure(let error):
//                guard let webserviceError = error as? WebserviceError else {
//                    XCTFail()
//                    return
//                }
//
//                XCTAssertEqual(WebserviceError.unknown(nil), webserviceError,
//                               "Expect unknown, got \(webserviceError)")
//            }
//        }
//    }
//
//    func testHTTPURLResponseSuccess() {
//        let response = HTTPURLResponse(url: URL.dummy(),
//                                       statusCode: 201,
//                                       httpVersion: nil,
//                                       headerFields: nil)!
//        XCTAssertTrue(response.isSuccessful)
//    }
//
//    func testHTTPURLResponseError() {
//        let response = HTTPURLResponse(url: URL.dummy(),
//                                       statusCode: 403,
//                                       httpVersion: nil,
//                                       headerFields: nil)!
//        XCTAssertTrue(response.isError)
//    }
}
