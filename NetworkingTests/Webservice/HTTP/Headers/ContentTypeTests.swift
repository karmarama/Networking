import XCTest
@testable import Networking

final class ContentTypeTests: XCTestCase {
    func testJSONContentTypeHeader() {
        let contentType = JSONContentType()
        XCTAssertEqual(contentType.header.0, "Content-Type")
        XCTAssertEqual(contentType.header.1, "application/json")
    }

    func testJSONContentTypeEncoder() {
        let contentType = JSONContentType()
        XCTAssertTrue(contentType.encoder.self is JSONEncoder)
    }

    func testJSONContentTypeDecoder() {
        let contentType = JSONContentType()
        XCTAssertTrue(contentType.decoder.self is JSONDecoder)
    }
}
