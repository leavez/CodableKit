//
//  CodableKitTests.swift
//  JSONTests
//
//  Created by 李孛 on 2018/6/24.
//

import XCTest
@testable import JSON

final class CodableKitTests: XCTestCase {
    func testAnyCodingKey() {
        XCTAssertEqual(AnyCodingKey.super.stringValue, "super")
        do {
            let key = AnyCodingKey(stringValue: "key")!
            XCTAssertEqual(key.stringValue, "key")
            XCTAssertEqual(key.intValue, nil)
        }
        do {
            let key = AnyCodingKey(intValue: 42)!
            XCTAssertEqual(key.stringValue, "42")
            XCTAssertEqual(key.intValue, 42)
        }
        do {
            let key = AnyCodingKey(index: 0)
            XCTAssertEqual(key.stringValue, "Index 0")
            XCTAssertEqual(key.intValue, 0)
        }
    }

    func testSnakeCasedString() {
        let data = [
            ("camelCase", "camel_case"),
            ("theHTTPMethod", "the_http_method"),
            ("camel2Camel2Case", "camel2_camel2_case"),
            ("HTTPResponseCodeXYZ", "http_response_code_xyz"),
            ("already_snake_cased", "already_snake_cased"),
            ("", ""),
        ]
        for (input, output) in data {
            XCTAssertEqual(input.snakeCased(), output)
        }
    }
}
