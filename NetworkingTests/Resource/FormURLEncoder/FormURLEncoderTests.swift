import XCTest
@testable import Networking
final class FormURLEncoderTests: XCTestCase {

    struct LotsOfTypes: Codable {
        let canBeNil: String?
        let bool: Bool
        let double: Double
        let int: Int
        let int8: Int8
        let int16: Int16
        let int32: Int32
        let int64: Int64
        let uInt: UInt
        let uInt8: UInt8
        let uInt16: UInt16
        let uInt32: UInt32
        let uInt64: UInt64
    }

    struct Product: Codable {
        var name: String
        var price: Float
        var info: String
    }

    struct Address: Codable {
        var street: String
        var city: String
        var state: String
    }

    struct Store: Codable {
        var name: String
        var address: Address // nested struct
        var products: [String: Product] // array
    }

    func testSimpleEncoding() throws {
        let iPhone = Product(name: "iPhone X", price: 1_000, info: "Our best iPhone yet!")
        let formEncoder = FormURLEncoder()
        let formString = try formEncoder.stringEncode(iPhone)
        XCTAssertEqual(formString, "info=Our+best+iPhone+yet!&name=iPhone+X&price=1000.0")
    }

    func testSimpleEncodingData() throws {
        let iPhone = Product(name: "iPhone X", price: 1_000, info: "Our best iPhone yet!")
        let formEncoder = FormURLEncoder()
        let formString = try formEncoder.stringEncode(iPhone)
        let formStringData = formString.data(using: .utf8)!
        let formData = try formEncoder.encode(iPhone)
        XCTAssertEqual(formData, formStringData)
    }

    func testNestedEncoding() throws {
        let iPhone = Product(name: "iPhone X", price: 1_000, info: "Our best iPhone yet!")
        let macBook = Product(name: "Mac Book Pro", price: 2_000, info: "Early 2019")
        let watch = Product(name: "Apple Watch", price: 500, info: "Series 4")

        let products =  ["phone": iPhone, "mac": macBook, "watch": watch]

        let formEncoder = FormURLEncoder()
        let formString = try formEncoder.stringEncode(products)
            XCTAssertEqual(formString, """
mac%5Binfo%5D=Early+2019&mac%5Bname%5D=Mac+Book+Pro&mac%5Bprice%5D=2000.0&phone%5Binfo%5D=Our+best+iPhone+yet!
&phone%5Bname%5D=iPhone+X&phone%5Bprice%5D=1000.0&watch%5Binfo%5D=Series+4&watch%5Bname%5D=Apple+Watch
&watch%5Bprice%5D=500.0
""".replacingOccurrences(of: "\n", with: ""))
    }

    func testTypesEncoding() throws {

        let types = LotsOfTypes(canBeNil: nil,
                                bool: true,
                                double: 1.0,
                                int: 2,
                                int8: 3,
                                int16: 4,
                                int32: 5,
                                int64: 6,
                                uInt: 7,
                                uInt8: 8,
                                uInt16: 9,
                                uInt32: 10,
                                uInt64: 11)

        let formString = try FormURLEncoder().stringEncode(types)
        XCTAssertEqual(formString,
                       """
bool=true&double=1.0&int=2&int16=4&int32=5&int64=6&int8=3&uInt=7&uInt16=9&uInt32=10&uInt64=11&uInt8=8
""")
    }

    func testSingleStringEncoding() {
         XCTAssertThrowsError( try FormURLEncoder().stringEncode("Test"))
    }

    func testSingleBoolEncoding() {
          XCTAssertThrowsError( try FormURLEncoder().stringEncode(true))
    }

    func testSingleDoubleEncoding() {
          XCTAssertThrowsError( try FormURLEncoder().stringEncode(Double(1.0)))
    }

    func testSingleFloatEncoding() {
         XCTAssertThrowsError( try FormURLEncoder().stringEncode(Float(1.0)))
    }

    func testSingleIntEncoding() {
           XCTAssertThrowsError( try FormURLEncoder().stringEncode(Int(1)))
    }

    func testSingleUIntEncoding() {
        XCTAssertThrowsError( try FormURLEncoder().stringEncode(UInt(1)))
    }

    func testSingleUInt8Encoding() {
     XCTAssertThrowsError( try  FormURLEncoder().stringEncode(UInt8(1)))
    }

    func testSingleUInt16Encoding() {
      XCTAssertThrowsError( try FormURLEncoder().stringEncode(UInt16(1)))
    }

    func testSingleInt16Encoding() {
        XCTAssertThrowsError( try FormURLEncoder().stringEncode(Int16(1)))
    }

    func testSingleInt8Encoding() {
         XCTAssertThrowsError(try FormURLEncoder().stringEncode(Int8(1)))
    }

    func testSingleInt32Encoding() {
        XCTAssertThrowsError( try FormURLEncoder().stringEncode(Int32(1)))
    }

    func testSingleInt64Encoding() {
      XCTAssertThrowsError(try FormURLEncoder().stringEncode(Int64(1)))
    }

    func testSingleUInt32Encoding() {
        XCTAssertThrowsError( try FormURLEncoder().stringEncode(UInt32(1)))
    }

    func testSingleUInt64Encoding() {
        XCTAssertThrowsError( try FormURLEncoder().stringEncode(UInt64(1)))
    }

    func testUnkeyeyedArrayCustomTypeEncoding() {
        let iPhone = Product(name: "iPhone X", price: 1_000, info: "Our best iPhone yet!")
        let macBook = Product(name: "Mac Book Pro", price: 2_000, info: "Early 2019")
        let watch = Product(name: "Apple Watch", price: 500, info: "Series 4")

        let products =  [ iPhone, macBook, watch]

        let formEncoder = FormURLEncoder()
        XCTAssertThrowsError(try formEncoder.stringEncode(products))
    }
}
