import XCTest
@testable import Networking

final class JSONDecoderTests: XCTestCase {`
    private struct TestData: Codable, Equatable {
        let clientName: String
    }

    func testDecodeWithData() throws {
        let jsonData = Data("{\"client_name\":\"Karmarama\"}".utf8)
        let decoder = JSONDecoder()

        decoder.keyDecodingStrategy = .convertFromSnakeCase

        XCTAssertEqual(try decoder.decode(TestData.self,
                                          from: jsonData,
                                          response: HTTPURLResponse()), TestData(clientName: "Karmarama"))
    }

    func testDecodeWithoutData() throws {
        XCTAssertThrowsError(try JSONDecoder().decode(TestData.self,
                                                  from: nil,
                                                  response: HTTPURLResponse())) { error in
                                                    XCTAssertTrue((error as? JSONDecoder.Error) == .noData)
            }
    }
}
