//
//  JSONTests.swift
//  JSONTests
//
//  Created by 李孛 on 2018/6/13.
//

import XCTest
@testable import JSON

class JSONTests: XCTestCase {
    func testInitializers() {
        var json: JSON

        let string = "string"
        json = .string(string)
        XCTAssertEqual(json, JSON(string))

        json = .number(42)
        XCTAssertEqual(json, JSON(42))
        XCTAssertEqual(json, JSON(42 as Int8))
        XCTAssertEqual(json, JSON(42 as Int16))
        XCTAssertEqual(json, JSON(42 as Int32))
        XCTAssertEqual(json, JSON(42 as Int64))
        XCTAssertEqual(json, JSON(42 as UInt))
        XCTAssertEqual(json, JSON(42 as UInt8))
        XCTAssertEqual(json, JSON(42 as UInt16))
        XCTAssertEqual(json, JSON(42 as UInt32))
        XCTAssertEqual(json, JSON(42 as UInt64))
        XCTAssertEqual(json, JSON(42 as Float))
        XCTAssertEqual(json, JSON(42.0))

        json = JSON(1 as NSNumber)
        XCTAssertEqual(json, JSON.number(1))
        XCTAssertNotEqual(json, JSON.true)

        json = JSON(true as NSNumber)
        XCTAssertEqual(json, JSON.true)
        XCTAssertNotEqual(json, JSON.number(1))
    }
}
