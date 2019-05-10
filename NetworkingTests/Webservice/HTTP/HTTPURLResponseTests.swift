import XCTest
@testable import Networking

final class HTTPURLResponseTests: XCTestCase {
    func testSuccess() {
        for code in 100...399 {
            let response = HTTPURLResponse(url: URL(string: "www.karmarama.com")!,
                                           statusCode: code,
                                           httpVersion: "",
                                           headerFields: nil)!
            XCTAssertEqual(response.isSuccessful, true)
        }
    }

    func testFailureIsOpposite() {
        for code in 100...599 {
            let response = HTTPURLResponse(url: URL(string: "www.karmarama.com")!,
                                           statusCode: code,
                                           httpVersion: "",
                                           headerFields: nil)!
            XCTAssertEqual(!response.isSuccessful, response.isError)
        }
    }
}
