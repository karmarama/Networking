import XCTest
@testable import Networking

final class ResourceTests: XCTestCase {
    private let emptyDecoding = ResourceDecodingExecution.background(EmptyDecoder())

    func testURLRequestFromResourceNoScheme() throws {
        let resource = Resource<Empty, Empty>(endpoint: "/path/to/resource", decoding: emptyDecoding)
        let request = try URLRequest(resource: resource,
                                     requestBehavior: EmptyRequestBehavior(),
                                     baseURL: URL(string: "www.karmarama.com")!)

        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.httpBody, nil)
        XCTAssertEqual(request.allHTTPHeaderFields, [:])
        XCTAssertEqual(request.url, URL(string: "www.karmarama.com/path/to/resource"))
    }

    func testURLRequestFromResourceWithScheme() throws {
        let resource = Resource<Empty, Empty>(endpoint: "/path/to/resource", decoding: emptyDecoding)
        let request = try URLRequest(resource: resource,
                                     requestBehavior: EmptyRequestBehavior(),
                                     baseURL: URL(string: "https://www.karmarama.com")!)

        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.httpBody, nil)
        XCTAssertEqual(request.allHTTPHeaderFields, [:])
        XCTAssertEqual(request.url, URL(string: "https://www.karmarama.com/path/to/resource"))
    }

    func testURLRequestFromResourceWithQuery() throws {
        let resource = Resource<Empty, Empty>(endpoint: "/path/to/resource",
                                              queryParameters: [URLQueryItem(name: "testKey", value: "testValue")],
                                              decoding: emptyDecoding)

        let request = try URLRequest(resource: resource,
                                     requestBehavior: EmptyRequestBehavior(),
                                     baseURL: URL(string: "https://www.karmarama.com")!)

        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.httpBody, nil)
        XCTAssertEqual(request.allHTTPHeaderFields, [:])
        XCTAssertEqual(request.url, URL(string: "https://www.karmarama.com/path/to/resource?testKey=testValue"))
    }

    func testURLRequestFromResourceWithPOSTBody() throws {
        let resource = Resource<[String: String], Empty>(endpoint: "/path/to/resource",
                                                         method: .post,
                                                         body: HTTP.Body(data: ["Test": "Test"],
                                                                         contentType: JSONContentType()),
                                                         decoding: emptyDecoding)

        let request = try URLRequest(resource: resource,
                                     requestBehavior: EmptyRequestBehavior(),
                                     baseURL: URL(string: "https://www.karmarama.com")!)

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertNotNil(request.httpBody)
        XCTAssertEqual(request.allHTTPHeaderFields, ["Content-Type": "application/json"])
        XCTAssertEqual(request.url, URL(string: "https://www.karmarama.com/path/to/resource"))
    }

    func testURLRequestFromResourceMalformedResourceError() {
        let resource = Resource<Empty, Empty>(endpoint: "path/to/resource", decoding: emptyDecoding)

        let expect = expectation(description: "Wait for error")

        XCTAssertThrowsError(try URLRequest(resource: resource,
                                            requestBehavior: EmptyRequestBehavior(),
                                            baseURL: URL(string: "https://www.karmarama.com")!)) { _ in
                                                expect.fulfill()
        }

        waitForExpectations(timeout: 0.5, handler: nil)
    }

    func testURLRequestFromResourceMalformedURLError() {
        let resource = Resource<Empty, Empty>(endpoint: "path/to/resource", decoding: emptyDecoding)

        let expect = expectation(description: "Wait for error")

        // stackoverflow.com/a/55627352/614442
        XCTAssertThrowsError(try URLRequest(resource: resource,
                                            requestBehavior: EmptyRequestBehavior(),
                                            baseURL: URL(string: "a://@@")!)) { _ in
                                                expect.fulfill()
        }

        waitForExpectations(timeout: 0.5, handler: nil)
    }
}
