import Foundation

struct CustomEncodable: Encodable {
    let product: Product?
    enum CodingKeys: String, CodingKey {
        case product
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let product = product {
            try container.encode(product)
        } else {
            try container.encodeNil()
        }
    }
}

class Product: Encodable {
    var name: String
    var price: Float
    var info: String?

    init(name: String, price: Float, info: String?) {
        self.name = name
        self.price = price
        self.info = info
    }

    enum CodingKeys: String, CodingKey {
        case name
        case price
        case info
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(price, forKey: .price)
        if let info = info {
            try container.encode(info, forKey: .info)
        } else {
            try container.encodeNil(forKey: .info)
        }
    }
}

class UnkeyedStore: Encodable {
    var name: String
    var products: [Product]?

    init(name: String, products: [Product]?) {
        self.name = name
        self.products = products
    }

    enum CodingKeys: String, CodingKey {
        case name
        case products
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        var nestedContainer = container.nestedUnkeyedContainer(forKey: .products)
        if let products = products {
        try nestedContainer.encode(products)
        } else {
            try nestedContainer.encodeNil()
        }
    }
}

struct KeyedStore: Encodable {
    var name: String
    var product: Product

    enum CodingKeys: String, CodingKey {
        case name
        case product
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        var nestedContainer = container.nestedContainer(keyedBy: Product.CodingKeys.self, forKey: .product)
        try nestedContainer.encode(product.name, forKey: .name)
        try nestedContainer.encode(product.price, forKey: .price)
        if let info = product.info {
            try nestedContainer.encode(info, forKey: .info)
        } else {
            try nestedContainer.encodeNil(forKey: .info)
        }
    }
}

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

struct UnKeyedThings: Encodable {
    let things: [[String]]
    enum CodingKeys: String, CodingKey {
        case things
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for thing in things {
            var nestedUnkeyedContainer = container.nestedUnkeyedContainer()
            try nestedUnkeyedContainer.encode(thing)
        }
    }
}

struct KeyedThings: Encodable {
    let products: [Product]
    enum CodingKeys: String, CodingKey {
        case products
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for product in products {
            var nestedKeyedContainer = container.nestedContainer(keyedBy: Product.CodingKeys.self)
            try nestedKeyedContainer.encode(product.name, forKey: .name)
            try nestedKeyedContainer.encode(product.price, forKey: .price)
        }
    }
}

class SubProduct: Product {
    let extraField: String

    init(name: String, price: Float, info: String?, extraField: String) {
        self.extraField = extraField
        super.init(name: name, price: price, info: info)
    }

    enum SubCodingKeys: String, CodingKey {
        case extraField
        case `super`
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: SubCodingKeys.self)
        try container.encode(extraField, forKey: .extraField)

        let superEncoder = container.superEncoder()
        var productContainer = superEncoder.container(keyedBy: CodingKeys.self)
        try productContainer.encode(name, forKey: .name)
        try productContainer.encode(price, forKey: .price)
        if let info = info {
            try productContainer.encode(info, forKey: .info)
        } else {
            try productContainer.encodeNil(forKey: .info)
        }
    }
}

struct SubProducts: Encodable {
    let subProducts: [SubProduct]

    enum CodingKeys: String, CodingKey {
        case subProduct
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        let superEncoder = container.superEncoder()
        var superContainer = superEncoder.unkeyedContainer()
        try superContainer.encode(subProducts)
    }
}
