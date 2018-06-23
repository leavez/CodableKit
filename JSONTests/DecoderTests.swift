//
//  DecoderTests.swift
//  JSONTests
//
//  Created by 李孛 on 2018/6/21.
//

import XCTest
@testable import JSON

final class DecoderTests: XCTestCase {
    func testUnboxing() {
        let decoder = JSON._Decoder(codingPath: [], options: JSON.Decoder.Options(userInfo: [:]))
        XCTAssertThrowsError(try decoder.unbox("string", as: Bool.self))
        XCTAssertEqual(try! decoder.unbox(true, as: Bool.self), true)
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
    }

    struct Model: Decodable {}

    func testSingleValueDecodingContainer() {
        let decoder = JSON._Decoder(codingPath: [], options: JSON.Decoder.Options(userInfo: [:]))
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

    func testKeyedDecodingContainer() {
        enum CodingKeys: String, CodingKey {
            case key
        }
        let decoder = JSON._Decoder(codingPath: [], options: JSON.Decoder.Options(userInfo: [:]))
        do {
            decoder.stroage = [["key": "value"]]
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
            decoder.stroage = [["key": ["key": "value"]]]
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
            decoder.stroage = [["key": ["key": "value"]]]
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            XCTAssertThrowsError(try container.superDecoder())
            let superDecoder = try! container.superDecoder(forKey: .key)
            XCTAssertEqual(superDecoder.codingPath as! [CodingKeys], [.key])
        }
    }
}
