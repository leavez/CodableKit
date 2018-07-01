//
//  DecoderTests.swift
//  CodableKitTests
//
//  Created by 李孛 on 2018/6/21.
//

import XCTest
@testable import CodableKit

final class DecoderTests: XCTestCase {
    let options = JSON.Decoder().options

    func testUnboxing() {
        let decoder = JSON._Decoder(codingPath: [], options: options)
        XCTAssertThrowsError(try decoder.unbox("string", as: Bool.self))
        XCTAssertEqual(try! decoder.unbox(true, as: Bool.self), true)
        XCTAssertEqual(try! decoder.unbox(false, as: Bool.self), false)
        XCTAssertThrowsError(try decoder.unbox("string", as: Int.self))
        XCTAssertThrowsError(try decoder.unbox(128, as: Int8.self))
        XCTAssertEqual(try! decoder.unbox(42, as: Int16.self), 42)
        XCTAssertEqual(try! decoder.unbox(42, as: Int32.self), 42)
        XCTAssertEqual(try! decoder.unbox(42, as: Int64.self), 42)
        XCTAssertEqual(try! decoder.unbox(42, as: UInt.self), 42)
        XCTAssertEqual(try! decoder.unbox(42, as: UInt8.self), 42)
        XCTAssertEqual(try! decoder.unbox(42, as: UInt16.self), 42)
        XCTAssertEqual(try! decoder.unbox(42, as: UInt32.self), 42)
        XCTAssertEqual(try! decoder.unbox(42, as: UInt64.self), 42)
        XCTAssertEqual(try! decoder.unbox(42, as: Float.self), 42)
        XCTAssertEqual(try! decoder.unbox(42, as: Double.self), 42)
        XCTAssertThrowsError(try decoder.unbox(42, as: String.self))
        XCTAssertEqual(try! decoder.unbox("string", as: String.self), "string")
        XCTAssertThrowsError(try decoder.unbox(nil, as: Bool.self))
    }

    struct Model: Decodable {}

    func testSingleValueDecodingContainer() {
        let decoder = JSON._Decoder(codingPath: [], options: options)
        decoder.stroage = [nil]
        XCTAssertTrue(decoder.decodeNil())
        decoder.stroage = [true]
        XCTAssertEqual(try! decoder.decode(Bool.self), true)
        decoder.stroage = [42]
        XCTAssertEqual(try! decoder.decode(Int.self), 42)
        XCTAssertEqual(try! decoder.decode(Int8.self), 42)
        XCTAssertEqual(try! decoder.decode(Int16.self), 42)
        XCTAssertEqual(try! decoder.decode(Int32.self), 42)
        XCTAssertEqual(try! decoder.decode(Int64.self), 42)
        XCTAssertEqual(try! decoder.decode(UInt.self), 42)
        XCTAssertEqual(try! decoder.decode(UInt8.self), 42)
        XCTAssertEqual(try! decoder.decode(UInt16.self), 42)
        XCTAssertEqual(try! decoder.decode(UInt32.self), 42)
        XCTAssertEqual(try! decoder.decode(UInt64.self), 42)
        XCTAssertEqual(try! decoder.decode(Float.self), 42)
        XCTAssertEqual(try! decoder.decode(Double.self), 42)
        decoder.stroage = ["string"]
        XCTAssertEqual(try! decoder.decode(String.self), "string")
        XCTAssertNotNil(try? decoder.decode(Model.self))
    }

    enum CodingKeys: String, CodingKey {
        case key
    }

    func testKeyedDecodingContainer() {
        let decoder = JSON._Decoder(codingPath: [], options: options)
        do {
            decoder.stroage = [["key": "string"]]
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            XCTAssertEqual(container.allKeys, [.key])
            XCTAssertTrue(container.contains(.key))
        }
        do {
            decoder.stroage = [[:]]
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            XCTAssertThrowsError(try container.decodeNil(forKey: .key))
        }
        do {
            decoder.stroage = [["key": nil]]
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            XCTAssertTrue(try! container.decodeNil(forKey: .key))
        }
        do {
            decoder.stroage = [["key": true]]
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            XCTAssertTrue(try! container.decode(Bool.self, forKey: .key))
        }
        do {
            decoder.stroage = [["key": 42]]
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            XCTAssertEqual(try! container.decode(Int.self, forKey: .key), 42)
            XCTAssertEqual(try! container.decode(Int8.self, forKey: .key), 42)
            XCTAssertEqual(try! container.decode(Int16.self, forKey: .key), 42)
            XCTAssertEqual(try! container.decode(Int32.self, forKey: .key), 42)
            XCTAssertEqual(try! container.decode(Int64.self, forKey: .key), 42)
            XCTAssertEqual(try! container.decode(UInt.self, forKey: .key), 42)
            XCTAssertEqual(try! container.decode(UInt8.self, forKey: .key), 42)
            XCTAssertEqual(try! container.decode(UInt16.self, forKey: .key), 42)
            XCTAssertEqual(try! container.decode(UInt32.self, forKey: .key), 42)
            XCTAssertEqual(try! container.decode(UInt64.self, forKey: .key), 42)
            XCTAssertEqual(try! container.decode(Float.self, forKey: .key), 42)
            XCTAssertEqual(try! container.decode(Double.self, forKey: .key), 42)
        }
        do {
            decoder.stroage = [["key": "string"]]
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            XCTAssertEqual(try! container.decode(String.self, forKey: .key), "string")
            XCTAssertNotNil(try? container.decode(Model.self, forKey: .key))
            XCTAssertThrowsError(try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key))
        }
        do {
            decoder.stroage = [["key": ["key": "string"]]]
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            let nestedContainer = try! container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key)
            XCTAssertEqual(nestedContainer.codingPath as! [CodingKeys], [.key])
            XCTAssertThrowsError(try container.nestedUnkeyedContainer(forKey: .key))
        }
        do {
            decoder.stroage = [["key": [42]]]
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            let nestedUnkeyedContainer = try! container.nestedUnkeyedContainer(forKey: .key)
            XCTAssertEqual(nestedUnkeyedContainer.codingPath as! [CodingKeys], [.key])
            XCTAssertEqual(nestedUnkeyedContainer.count, 1)
        }
        do {
            decoder.stroage = [["key": ["key": "string"]]]
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            XCTAssertThrowsError(try container.superDecoder())
            let superDecoder = try! container.superDecoder(forKey: .key)
            XCTAssertEqual(superDecoder.codingPath as! [CodingKeys], [.key])
        }
    }

    func testUnkeyedDecodingContainer() {
        let decoder = JSON._Decoder(codingPath: [], options: options)
        do {
            decoder.stroage = [[]]
            var container = try! decoder.unkeyedContainer()
            XCTAssertThrowsError(try container.decodeNil())
        }
        do {
            decoder.stroage = [[nil, true, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, "string", 42,
                                [42], ["key": "string"], []]]
            var container = try! decoder.unkeyedContainer()
            XCTAssertTrue(try! container.decodeNil())
            XCTAssertFalse(try! container.decodeNil())
            XCTAssertTrue(try! container.decode(Bool.self))
            XCTAssertEqual(try! container.decode(Int.self), 42)
            XCTAssertEqual(try! container.decode(Int8.self), 42)
            XCTAssertEqual(try! container.decode(Int16.self), 42)
            XCTAssertEqual(try! container.decode(Int32.self), 42)
            XCTAssertEqual(try! container.decode(Int64.self), 42)
            XCTAssertEqual(try! container.decode(UInt.self), 42)
            XCTAssertEqual(try! container.decode(UInt8.self), 42)
            XCTAssertEqual(try! container.decode(UInt16.self), 42)
            XCTAssertEqual(try! container.decode(UInt32.self), 42)
            XCTAssertEqual(try! container.decode(UInt64.self), 42)
            XCTAssertEqual(try! container.decode(Float.self), 42)
            XCTAssertEqual(try! container.decode(Double.self), 42)
            XCTAssertEqual(try! container.decode(String.self), "string")
            XCTAssertNotNil(try! container.decode(Model.self))
            XCTAssertThrowsError(try container.nestedContainer(keyedBy: CodingKeys.self))
            XCTAssertNotNil(try? container.nestedUnkeyedContainer())
            XCTAssertThrowsError(try container.nestedUnkeyedContainer())
            XCTAssertNotNil(try? container.nestedContainer(keyedBy: CodingKeys.self))
            XCTAssertNoThrow(try container.superDecoder())
        }
    }

    func test_Decoder() {
        let decoder = JSON._Decoder(codingPath: [], options: options)
        XCTAssertEqual(decoder.userInfo.count, 0)
        decoder.stroage = ["string"]
        XCTAssertThrowsError(try decoder.unkeyedContainer())
    }

    func testDecoder() {
        struct Model: Decodable {
            let string: String
            let number: Int
        }
        let decoder = JSON.Decoder()
        do {
            let json: [String: JSON] = ["string": "string", "number": 42]
            let model = try! decoder.decode(Model.self, from: json)
            XCTAssertEqual(model.string, "string")
            XCTAssertEqual(model.number, 42)
        }
        do {
            let json: [JSON] = [["string": "string", "number": 42]]
            let model = (try! decoder.decode([Model].self, from: json))[0]
            XCTAssertEqual(model.string, "string")
            XCTAssertEqual(model.number, 42)
        }
        do {
            let data = """
                {
                    "string": "string",
                    "number": 42
                }
                """
                .data(using: .utf8)!
            let model = try! decoder.decode(Model.self, from: data)
            XCTAssertEqual(model.string, "string")
            XCTAssertEqual(model.number, 42)
        }
    }
}
