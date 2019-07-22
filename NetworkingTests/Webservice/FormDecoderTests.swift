import XCTest
@testable import Networking

final class FormDecoderTests: XCTestCase {

    struct Product: Codable {
        var name: String?
        var price: Float
        var info: String
    }

    struct Price: Codable {
        var pounds: Int
        var dollars: Int
    }

    func testDecoding() {

        let iPhone = Product(name: "bananan", price: 1_000, info: "Our best iPhone yet!")
        do {
            let formData = try FormEncoder().encode(iPhone)
            let formString = (String(data: formData, encoding: .utf8)!)
            let decoder = FormDecoder(formString)
            let product = try Product(from: decoder)
            print(product)
        } catch let error {
            print(error)
        }
    }

//    func testNestedDecoding() {
//
//        let iPhone = Product(name: "iPhone X", price: Price(pounds: 4, dollars: 12), info: "Our best iPhone yet!")
//
//        let formEncoder = FormEncoder()
//        do {
//            let formData = try formEncoder.encode(iPhone)
//            let formString = (String(data: formData, encoding: .utf8)!)
//            print(formString)
//            let decoder = FormDecoder(formString)
//            let decodedProducts = try Product.init(from: decoder)
//            print (decodedProducts)
//        } catch {
//            print("Encoding failed: \(error)")
//            XCTFail("failed to encode")
//        }
//print("boo")
//
//    }

}
