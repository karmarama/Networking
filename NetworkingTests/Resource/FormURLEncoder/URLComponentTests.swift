import XCTest
@testable import Networking

final class URLComponentsTests: XCTestCase {

    func testQueryStringWithValue() {
        let query1 = URLQueryItem(name: "q1", value: "test")
        var components = URLComponents()
        components.queryItems = [query1]
        XCTAssertEqual(components.queryString, "q1=test")
    }

    func testQueryStringWithMultipleValuea() {
        let query1 = URLQueryItem(name: "q1", value: "test")
        let query2 = URLQueryItem(name: "q2", value: "again")
        var components = URLComponents()
        components.queryItems = [query1, query2]
        XCTAssertEqual(components.queryString, "q1=test&q2=again")
    }

    func testQueryStringWithNil() {
        var components = URLComponents()
        components.queryItems = nil
        XCTAssertEqual(components.queryString, "")
    }

    func testQueryStringWithNilValue() {
        var components = URLComponents()
          let query1 = URLQueryItem(name: "q1", value: nil)
        components.queryItems = [query1]
        XCTAssertEqual(components.queryString, "q1")
    }
}
