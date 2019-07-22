import XCTest
@testable import Networking

final class FormEncoderTests: XCTestCase {

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

    func testArrayEncoding() {
        let iPhone = Product(name: "iPhone X", price: 1_000, info: "Our best iPhone yet!")
        let macBook = Product(name: "Mac Book Pro", price: 2_000, info: "Early 2019")
        let watch = Product(name: "Apple Watch", price: 500, info: "Series 4")

        let products =  [ iPhone, macBook, watch]

        let formEncoder = FormEncoder()
        do {
            //swiftlint:disable line_length
            let formString = try formEncoder.stringEncode(products)
            print (formString)
            XCTAssertEqual(formString, "mac%5Binfo%5D=Early+2019&mac%5Bname%5D=Mac+Book+Pro&mac%5Bprice%5D=2000.0&phone%5Binfo%5D=Our+best+iPhone+yet!&phone%5Bname%5D=iPhone+X&phone%5Bprice%5D=1000.0&watch%5Binfo%5D=Series+4&watch%5Bname%5D=Apple+Watch&watch%5Bprice%5D=500.0")
        } catch FormEncoder.Error.missingKeyForValue {
            print("test oassed)")
        } catch {
            XCTFail("wrong error")
        }
    }
}
