//
//  CodableKitTests.swift
//  CodableKitTests
//
//  Created by 李孛 on 2018/6/26.
//

import XCTest
@testable import CodableKit

final class CodableKitTests: XCTestCase {
    func testString() {
        let tests = [
            ("", ""),
            ("property", "property"),
            ("abcDefGhi", "abc_def_ghi"),
            ("abcHTTPNice", "abc_http_nice"),
            ("abc_def_ghi", "abc_def_ghi"),
        ]
        for (input, output) in tests {
            XCTAssertEqual(input.snakeCased(), output)
        }
    }

    func testSnakeCasedCodingKey() {
        struct Model: Codable {
            let camelCasedProperty: String
            enum CodingKeys: String, SnakeCasedCodingKey {
                case camelCasedProperty
            }
        }

        let string = """
            {"camel_cased_property":"CodableKit"}
            """

        let data = string.data(using: .utf8)!
        let model = try! JSONDecoder().decode(Model.self, from: data)
        XCTAssertEqual(model.camelCasedProperty, "CodableKit")

        do {
            let data = try! JSONEncoder().encode(model)
            XCTAssertEqual(String(data: data, encoding: .utf8), string)
        }
    }

    func testKeyedDecodingContainerProtocol() {
        struct Model: Decodable {
            enum CodingKeys: CodingKey { case a, b, c }
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let _: Bool = try container.decode(.a)
                let _: Bool? = try container.decodeIfPresent(.b)
                let _: Bool? = container[.c]
            }
        }
        let data = """
            {
                "a": true,
                "b": null
            }
            """
            .data(using: .utf8)!
        XCTAssertNotNil(try? JSONDecoder().decode(Model.self, from: data))
    }

    func testAnyCodingKey() {
        do {
            let key = AnyCodingKey(stringValue: "key")
            XCTAssertEqual(key.stringValue, "key")
            XCTAssertNil(key.intValue)
        }

        do {
            let key = AnyCodingKey(intValue: 0)
            XCTAssertEqual(key.stringValue, "0")
            XCTAssertEqual(key.intValue, 0)
        }

        do {
            let key = AnyCodingKey(index: 0)
            XCTAssertEqual(key.stringValue, "Index 0")
            XCTAssertEqual(key.intValue, 0)
        }

        do {
            let key: AnyCodingKey = "key"
            XCTAssertEqual(key.stringValue, "key")
            XCTAssertNil(key.intValue)
        }

        struct Model: Codable {
            init(from decoder: Decoder) throws {
                let container = try decoder.container()
                _ = try container.nestedContainer(forKey: "nested_container")
                var nestedUnkeyedContainer = try container.nestedUnkeyedContainer(forKey: "nested_unkeyed_container")
                _ = try nestedUnkeyedContainer.nestedContainer()
            }

            func encode(to encoder: Encoder) throws {
                var container = encoder.container()
                _ = container.nestedContainer(forKey: "nested_container")
                var nestedUnkeyedContainer = container.nestedUnkeyedContainer(forKey: "nested_unkeyed_container")
                _ = nestedUnkeyedContainer.nestedContainer()
            }
        }

        let data = """
            {
                "nested_container": {},
                "nested_unkeyed_container": [{}]
            }
            """
            .data(using: .utf8)!

        let model = try! JSONDecoder().decode(Model.self, from: data)
        _ = try! JSONEncoder().encode(model)
    }
}
