//
//  DecoderTests.swift
//  JSONTests
//
//  Created by 李孛 on 2018/6/21.
//

import XCTest
@testable import JSON

final class DecoderTests: XCTestCase {
    struct NiceString: Decodable {
        let base: String

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            base = try container.decode(String.self)
        }
    }

    func testUnboxing() {
        let decoder = JSON._Decoder(codingPath: [], userInfo: [:])

        XCTAssertThrowsError(try decoder.unbox(42, as: Bool.self))
        XCTAssertEqual(try! decoder.unbox(true, as: Bool.self), true)

        XCTAssertThrowsError(try decoder.unbox(true, as: Int.self))
        XCTAssertThrowsError(try decoder.unbox(512, as: Int8.self))
        XCTAssertEqual(try! decoder.unbox(42, as: Int.self), 42)
        XCTAssertEqual(try! decoder.unbox(42, as: Int8.self), 42)
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
        XCTAssertEqual(try! decoder.unbox("String", as: String.self), "String")
    }

    func testSingleValueDecodingContainer() {
        let decoder = JSON._Decoder(codingPath: [], userInfo: [:])

        decoder.stroage = [nil]
        XCTAssertTrue(decoder.decodeNil())

        decoder.stroage = [true]
        XCTAssertTrue(try! decoder.decode(Bool.self))

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

        decoder.stroage = ["String"]
        XCTAssertEqual(try! decoder.decode(String.self), "String")

        decoder.stroage = ["a"]
        XCTAssertEqual((try! decoder.decode(NiceString.self)).base, "a")
    }

    func testKeyedDecodingContainer() {
        let decoder = JSON._Decoder(codingPath: [], userInfo: [:])

        enum CodingKeys: String, CodingKey {
            case a
        }

        do {
            decoder.stroage = [["a": 42]]
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            XCTAssertEqual(container.allKeys, [.a])
            XCTAssertTrue(container.contains(.a))
        }

        do {
            decoder.stroage = [[:]]
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            XCTAssertThrowsError(try container.decodeNil(forKey: .a))
        }

        do {
            decoder.stroage = [["a": nil]]
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            XCTAssertTrue(try! container.decodeNil(forKey: .a))
        }

        do {
            decoder.stroage = [["a": true]]
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            XCTAssertTrue(try! container.decode(Bool.self, forKey: .a))
        }

        do {
            decoder.stroage = [["a": 42]]
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            XCTAssertEqual(try! container.decode(Int.self, forKey: .a), 42)
            XCTAssertEqual(try! container.decode(Int8.self, forKey: .a), 42)
            XCTAssertEqual(try! container.decode(Int16.self, forKey: .a), 42)
            XCTAssertEqual(try! container.decode(Int32.self, forKey: .a), 42)
            XCTAssertEqual(try! container.decode(Int64.self, forKey: .a), 42)
            XCTAssertEqual(try! container.decode(UInt.self, forKey: .a), 42)
            XCTAssertEqual(try! container.decode(UInt8.self, forKey: .a), 42)
            XCTAssertEqual(try! container.decode(UInt16.self, forKey: .a), 42)
            XCTAssertEqual(try! container.decode(UInt32.self, forKey: .a), 42)
            XCTAssertEqual(try! container.decode(UInt64.self, forKey: .a), 42)
            XCTAssertEqual(try! container.decode(Float.self, forKey: .a), 42)
            XCTAssertEqual(try! container.decode(Double.self, forKey: .a), 42)
        }

        do {
            decoder.stroage = [["a": "string"]]
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            XCTAssertEqual(try! container.decode(String.self, forKey: .a), "string")
            XCTAssertEqual((try! container.decode(NiceString.self, forKey: .a)).base, "string")
            XCTAssertThrowsError(try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .a))
        }

        do {
            decoder.stroage = [["a": ["a": "string"]]]
            let container = try! decoder.container(keyedBy: CodingKeys.self)
            let nestedContainer = try! container.nestedContainer(keyedBy: CodingKeys.self, forKey: .a)
            XCTAssertEqual(nestedContainer.codingPath as! [CodingKeys], [.a])
            XCTAssertThrowsError(try container.nestedUnkeyedContainer(forKey: .a))
        }
    }
}
