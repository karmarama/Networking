import XCTest
@testable import Networking

final class HTTPBodyTests: XCTestCase {
    private struct TestType: Codable {
        let test: String
    }

    func testEncoding() throws {
        let contentType = JSONContentType()

        let content = TestType(test: "test")
        let body = HTTP.Body(data: content, contentType: contentType)

        let data = try body.encoded()

        let decoded = try JSONDecoder().decode(TestType.self, from: data)

        XCTAssertEqual(decoded.test, "test")
    }
}
