import XCTest
@testable import Networking

final class ContentTypeTests: XCTestCase {
    func testJSONContentTypeHeader() {
        let contentType = JSONContentType()
        XCTAssertEqual(contentType.header.0, "Content-Type")
        XCTAssertEqual(contentType.header.1, "application/json")
    }

    func testJSONContentTypeHeaderutf8() {
        let contentType = JSONContentType(charSet: .utf8)
        XCTAssertEqual(contentType.header.0, "Content-Type")
        XCTAssertEqual(contentType.header.1, "application/json; charset=\"UTF-8\"")
    }

    func testJSONContentTypeHeaderiso88591() {
        let contentType = JSONContentType(charSet: .iso88591)
        XCTAssertEqual(contentType.header.0, "Content-Type")
        XCTAssertEqual(contentType.header.1, "application/json; charset=\"ISO-8859-1\"")
    }

    func testJSONContentTypeHeaderCustom() {
        let contentType = JSONContentType(charSet: .custom("CUSTOM"))
        XCTAssertEqual(contentType.header.0, "Content-Type")
        XCTAssertEqual(contentType.header.1, "application/json; charset=\"CUSTOM\"")
    }

    func testJSONContentTypeEncoder() {
        let contentType = JSONContentType()
        XCTAssertTrue(contentType.encoder.self is JSONEncoder)
    }

    func testJSONContentTypeDecoder() {
        let contentType = JSONContentType()
        XCTAssertTrue(contentType.decoder.self is JSONDecoder)
    }

    func testFormContentTypeHeader() {
        let contentType = FormContentType()
        XCTAssertEqual(contentType.header.0, "Content-Type")
        XCTAssertEqual(contentType.header.1, "application/x-www-form-urlencoded")
    }

    func testFormContentTypeEncoder() {
        let contentType = FormContentType()
        XCTAssertTrue(contentType.encoder.self is FormEncoder)
    }

    func testFormContentTypeDecoder() {
        let contentType = FormContentType()
        XCTAssertNil(contentType.decoder)
    }
}
