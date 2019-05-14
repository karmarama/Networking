import XCTest
@testable import Networking

final class JSONDecoderTests: XCTestCase {

    private struct TestData: Codable, Equatable {
        let name: String
    }

    func testDecodeWithData() throws {
        let testData = TestData(name: "Karmarama")
        let jsonData = try JSONEncoder().encode(testData)

        XCTAssertEqual(try JSONDecoder().decode(TestData.self,
                                                from: jsonData,
                                                response: HTTPURLResponse()), testData)
    }

    func testDecodeWithoutData() throws {
        XCTAssertThrowsError(try JSONDecoder().decode(TestData.self,
                                                  from: nil,
                                                  response: HTTPURLResponse())) { error in
                                                    XCTAssertTrue((error as? JSONDecoder.Error) == .noData)
            }
    }
}
