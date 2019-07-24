import XCTest
@testable import Networking

final class FormURLEncoderTests: XCTestCase {

    func testSimpleEncoding() throws {
        let iPhone = Product(name: "iPhone X", price: 1_000, info: "Our best iPhone yet!")
        let formEncoder = FormURLEncoder()
        let formString = try formEncoder.stringEncode(iPhone)
        XCTAssertEqual(formString, "info=Our+best+iPhone+yet!&name=iPhone+X&price=1000.0")
    }

    func testSingleValueEncodableEncoding() {
        let iPhone = Product(name: "iPhone X", price: 1_000, info: "Our best iPhone yet!")
        let encodable = CustomEncodable(product: iPhone)
        let formEncoder = FormURLEncoder()
        XCTAssertThrowsError( try formEncoder.stringEncode(encodable))
    }

    func testSingleValueNilEncoding() {
        let encodable = CustomEncodable(product: nil)
        let formEncoder = FormURLEncoder()
        XCTAssertThrowsError( try formEncoder.stringEncode(encodable))
    }

    func testSimpleEncodingData() throws {
        let iPhone = Product(name: "iPhone X", price: 1_000, info: "Our best iPhone yet!")
        let formEncoder = FormURLEncoder()
        let formString = try formEncoder.stringEncode(iPhone)
        let formStringData = formString.data(using: .utf8)!
        let formData = try formEncoder.encode(iPhone)
        XCTAssertEqual(formData, formStringData)
    }

    func testEncodeNilForKeyedValue() throws {
        let product = Product(name: "test", price: 29, info: nil)
        let formEncoder = FormURLEncoder()
        let formString = try formEncoder.stringEncode(product)
        XCTAssertEqual(formString, "info=null&name=test&price=29.0")
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

    func testKeyedContainerWithNestedUnkeyedContainer() {
        let prod1 = Product(name: "iPhone", price: 2.0, info: "xxx")
        let prod2 = Product(name: "mac", price: 3.0, info: nil)
        let store = UnkeyedStore(name: "test", products: [prod1, prod2])
        XCTAssertThrowsError(try FormURLEncoder().encode(store))
    }

    func testKeyedContainerWithNestedUnkeyedNilContainer() {
        let store = UnkeyedStore(name: "test", products: nil)
        XCTAssertThrowsError(try FormURLEncoder().encode(store))
    }

    func testKeyedContainerWithNestedkeyedContainer() throws {
        let prod1 = Product(name: "iPhone", price: 2.0, info: "xxx")
        let store = KeyedStore(name: "test", product: prod1 )
        let formString = try FormURLEncoder().stringEncode(store)
        XCTAssertEqual(formString, "name=test&product%5Binfo%5D=xxx&product%5Bname%5D=iPhone&product%5Bprice%5D=2.0")
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

    func testUnkeyedContainerWithUnKeyedNestedContainer() {
        let stuff1 =  ["one", "two"]
        let stuff2 =  ["three", "four"]
        let things = UnKeyedThings(things: [stuff1, stuff2])
        let formEncoder = FormURLEncoder()
        XCTAssertThrowsError(try formEncoder.stringEncode(things))
    }

    func testUnkeyedContainerWitKeyedNestedContainer() throws {
        //Note - this test only encodes last value in Array - unkeyed arrays supported by form data. 
        let iPhone = Product(name: "iPhone X", price: 1_000, info: "Our best iPhone yet!")
        let macBook = Product(name: "Mac Book Pro", price: 2_000, info: "Early 2019")
        let watch = Product(name: "Apple Watch", price: 500, info: "Series 4")

        let products =  [ iPhone, macBook, watch]

        let things = KeyedThings(products: products)
        let formEncoder = FormURLEncoder()
        let formString = try formEncoder.stringEncode(things)
        XCTAssertEqual(formString, "name=Apple+Watch&price=500.0" )
    }
}
