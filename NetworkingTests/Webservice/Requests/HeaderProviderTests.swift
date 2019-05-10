import XCTest
@testable import Networking

final class HeaderProviderTests: XCTestCase {
    func testRequestModifierExistingHeader() {
        let headerProvider = HeaderProvider(headers: [("Content-Type", "application/json")])

        var request = URLRequest(url: URL(string: "www.karmarama.com")!)
        request.allHTTPHeaderFields = ["Accept": "application/json"]

        XCTAssertEqual(request.allHTTPHeaderFields?.count, 1)

        request = headerProvider.modify(planned: request)

        XCTAssertEqual(request.allHTTPHeaderFields?.count, 2)
        XCTAssertEqual(request.allHTTPHeaderFields?["Accept"], "application/json")
        XCTAssertEqual(request.allHTTPHeaderFields?["Content-Type"], "application/json")
    }

    func testRequestModifierOnlyHeader() {
        let headerProvider = HeaderProvider(headers: [("Content-Type", "application/json")])

        var request = URLRequest(url: URL(string: "www.karmarama.com")!)

        XCTAssertEqual(request.allHTTPHeaderFields, nil)

        request = headerProvider.modify(planned: request)

        XCTAssertEqual(request.allHTTPHeaderFields?.count, 1)
        XCTAssertEqual(request.allHTTPHeaderFields?["Content-Type"], "application/json")
    }

    func testRequestModifierReplacesExistingHeader() {
        let headerProvider = HeaderProvider(headers: [("Content-Type", "application/json")])

        var request = URLRequest(url: URL(string: "www.karmarama.com")!)
        request.allHTTPHeaderFields = ["Content-Type": "text/html"]

        XCTAssertEqual(request.allHTTPHeaderFields?.count, 1)

        request = headerProvider.modify(planned: request)

        XCTAssertEqual(request.allHTTPHeaderFields?.count, 1)
        XCTAssertEqual(request.allHTTPHeaderFields?["Content-Type"], "application/json")
    }
}
