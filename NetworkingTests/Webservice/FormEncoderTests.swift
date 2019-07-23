import XCTest
@testable import Networking
final class FormEncoderTests: XCTestCase {

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

    func testSimpleEncoding() {

        let iPhone = Product(name: "iPhone X", price: 1_000, info: "Our best iPhone yet!")

        let formEncoder = FormEncoder()
        do {
            let formString = try formEncoder.stringEncode(iPhone)
            print(formString)
            XCTAssertEqual(formString, "info=Our+best+iPhone+yet!&name=iPhone+X&price=1000.0")
        } catch {
            print("Encoding failed: \(error)")
            XCTFail("failed to encode")
        }
    }

    func testNestedEncoding() {
        let iPhone = Product(name: "iPhone X", price: 1_000, info: "Our best iPhone yet!")
        let macBook = Product(name: "Mac Book Pro", price: 2_000, info: "Early 2019")
        let watch = Product(name: "Apple Watch", price: 500, info: "Series 4")

        let products =  ["phone": iPhone, "mac": macBook, "watch": watch]

        let formEncoder = FormEncoder()
        do {
            //swiftlint:disable line_length
            let formString = try formEncoder.stringEncode(products)
            print (formString)
             XCTAssertEqual(formString, "mac%5Binfo%5D=Early+2019&mac%5Bname%5D=Mac+Book+Pro&mac%5Bprice%5D=2000.0&phone%5Binfo%5D=Our+best+iPhone+yet!&phone%5Bname%5D=iPhone+X&phone%5Bprice%5D=1000.0&watch%5Binfo%5D=Series+4&watch%5Bname%5D=Apple+Watch&watch%5Bprice%5D=500.0")
        } catch {
            print("Encoding failed: \(error)")
            XCTFail("failed to encode")
        }
    }

    func testTypesEncoding() {

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
        do {
        let formString = try FormEncoder().stringEncode(types)
        XCTAssertEqual(formString,
                       "bool=true&double=1.0&int=2&int16=4&int32=5&int64=6&int8=3&uInt=7&uInt16=9&uInt32=10&uInt64=11&uInt8=8")
        } catch {
            XCTFail("failed to encode")
        }
    }

    func testSingleStringEncoding() {
         XCTAssertThrowsError( try FormEncoder().stringEncode("Test"))
    }

    func testSingleBoolEncoding() {
          XCTAssertThrowsError( try FormEncoder().stringEncode(true))
    }

    func testSingleDoubleEncoding() {
          XCTAssertThrowsError( try FormEncoder().stringEncode(Double(1.0)))
    }

    func testSingleFloatEncoding() {
         XCTAssertThrowsError( try FormEncoder().stringEncode(Float(1.0)))
    }

    func testSingleIntEncoding() {
           XCTAssertThrowsError( try FormEncoder().stringEncode(Int(1)))
    }

    func testSingleUIntEncoding() {
        XCTAssertThrowsError( try FormEncoder().stringEncode(UInt(1)))
    }

    func testSingleUInt8Encoding() {
     XCTAssertThrowsError( try  FormEncoder().stringEncode(UInt8(1)))
    }

    func testSingleUInt16Encoding() {
      XCTAssertThrowsError( try FormEncoder().stringEncode(UInt16(1)))
    }

    func testSingleInt16Encoding() {
        XCTAssertThrowsError( try FormEncoder().stringEncode(Int16(1)))
    }

    func testSingleInt8Encoding() {
         XCTAssertThrowsError(try FormEncoder().stringEncode(Int8(1)))
    }

    func testSingleInt32Encoding() {
        XCTAssertThrowsError( try FormEncoder().stringEncode(Int32(1)))
    }

    func testSingleInt64Encoding() {
      XCTAssertThrowsError(try FormEncoder().stringEncode(Int64(1)))
    }

    func testSingleUInt32Encoding() {
        XCTAssertThrowsError( try FormEncoder().stringEncode(UInt32(1)))
    }

    func testSingleUInt64Encoding() {
        XCTAssertThrowsError( try FormEncoder().stringEncode(UInt64(1)))
    }

    func testUnkeyeyedArrayCustomTypeEncoding() {
        let iPhone = Product(name: "iPhone X", price: 1_000, info: "Our best iPhone yet!")
        let macBook = Product(name: "Mac Book Pro", price: 2_000, info: "Early 2019")
        let watch = Product(name: "Apple Watch", price: 500, info: "Series 4")

        let products =  [ iPhone, macBook, watch]

        let formEncoder = FormEncoder()
        XCTAssertThrowsError(try formEncoder.stringEncode(products))
    }
}
