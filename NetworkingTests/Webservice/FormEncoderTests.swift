import XCTest
@testable import Networking
//swiftlint:disable type_body_length
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
                       "bool=true&double=1.0&int16=4&int32=5&int64=6&int8=3&int=2&uInt16=9&uInt32=10&uInt64=11&uInt8=8&uInt=7")
        } catch {
            XCTFail("failed to encode")
        }
    }

    func testSingleStringEncoding() {
        let formEncoder = FormEncoder()
        do {
            let formString = try formEncoder.stringEncode("Test")
            print(formString)
        } catch FormEncoder.Error.unsupportedDataFormat {
            print("test passed")
        } catch {
            XCTFail("wrong error")
        }
    }

    func testSingleBoolEncoding() {
        let formEncoder = FormEncoder()
        do {
            let formString = try formEncoder.stringEncode(true)
            print(formString)
        } catch FormEncoder.Error.unsupportedDataFormat {
            print("test passed")
        } catch {
            XCTFail("wrong error")
        }
    }

    func testSingleDoubleEncoding() {
        let formEncoder = FormEncoder()
        do {
            let formString = try formEncoder.stringEncode(Double(1.0))
            print(formString)
        } catch FormEncoder.Error.unsupportedDataFormat {
            print("test passed")
        } catch {
            XCTFail("wrong error")
        }
    }

    func testSingleFloatEncoding() {
        let formEncoder = FormEncoder()
        do {
            let formString = try formEncoder.stringEncode(Float(1.0))
            print(formString)
        } catch FormEncoder.Error.unsupportedDataFormat {
            print("test passed")
        } catch {
            XCTFail("wrong error")
        }
    }

    func testSingleIntEncoding() {
        let formEncoder = FormEncoder()
        do {
            let formString = try formEncoder.stringEncode(Int(1))
            print(formString)
        } catch FormEncoder.Error.unsupportedDataFormat {
            print("test passed")
        } catch {
            XCTFail("wrong error")
        }
    }

    func testSingleUIntEncoding() {
        let formEncoder = FormEncoder()
        do {
            let formString = try formEncoder.stringEncode(UInt(1))
            print(formString)
        } catch FormEncoder.Error.unsupportedDataFormat {
            print("test passed")
        } catch {
            XCTFail("wrong error")
        }
    }

    func testSingleUInt8Encoding() {
        let formEncoder = FormEncoder()
        do {
            let formString = try formEncoder.stringEncode(UInt8(1))
            print(formString)
        } catch FormEncoder.Error.unsupportedDataFormat {
            print("test passed")
        } catch {
            XCTFail("wrong error")
        }
    }

    func testSingleUInt16Encoding() {
        let formEncoder = FormEncoder()
        do {
            let formString = try formEncoder.stringEncode(UInt16(1))
            print(formString)
        } catch FormEncoder.Error.unsupportedDataFormat {
            print("test passed")
        } catch {
            XCTFail("wrong error")
        }
    }

    func testSingleInt16Encoding() {
        let formEncoder = FormEncoder()
        do {
            let formString = try formEncoder.stringEncode(Int16(1))
            print(formString)
        } catch FormEncoder.Error.unsupportedDataFormat {
            print("test passed")
        } catch {
            XCTFail("wrong error")
        }
    }

    func testSingleInt8Encoding() {
        let formEncoder = FormEncoder()
        do {
            let formString = try formEncoder.stringEncode(Int8(1))
            print(formString)
        } catch FormEncoder.Error.unsupportedDataFormat {
            print("test passed")
        } catch {
            XCTFail("wrong error")
        }
    }

    func testSingleInt32Encoding() {
        let formEncoder = FormEncoder()
        do {
            let formString = try formEncoder.stringEncode(Int32(1))
            print(formString)
        } catch FormEncoder.Error.unsupportedDataFormat {
            print("test passed")
        } catch {
            XCTFail("wrong error")
        }
    }

    func testSingleInt64Encoding() {
        let formEncoder = FormEncoder()
        do {
            let formString = try formEncoder.stringEncode(Int64(1))
            print(formString)
        } catch FormEncoder.Error.unsupportedDataFormat {
            print("test passed")
        } catch {
            XCTFail("wrong error")
        }
    }

    func testSingleUInt32Encoding() {
        let formEncoder = FormEncoder()
        do {
            let formString = try formEncoder.stringEncode(UInt32(1))
            print(formString)
        } catch FormEncoder.Error.unsupportedDataFormat {
            print("test passed")
        } catch {
            XCTFail("wrong error")
        }
    }

    func testSingleUInt64Encoding() {
        let formEncoder = FormEncoder()
        do {
            let formString = try formEncoder.stringEncode(UInt64(1))
            print(formString)
        } catch FormEncoder.Error.unsupportedDataFormat {
            print("test passed")
        } catch {
            XCTFail("wrong error")
        }
    }

    func testUnkeyeyedArrayCustomTypeEncoding() {
        let iPhone = Product(name: "iPhone X", price: 1_000, info: "Our best iPhone yet!")
        let macBook = Product(name: "Mac Book Pro", price: 2_000, info: "Early 2019")
        let watch = Product(name: "Apple Watch", price: 500, info: "Series 4")

        let products =  [ iPhone, macBook, watch]

        let formEncoder = FormEncoder()
        do {
            let formString = try formEncoder.stringEncode(products)
            print(formString)
        } catch FormEncoder.Error.unsupportedDataFormat {
            print("test passed")
        } catch {
            XCTFail("wrong error")
        }
    }
}
