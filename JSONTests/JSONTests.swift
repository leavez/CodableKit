//
//  JSONTests.swift
//  JSONTests
//
//  Created by 李孛 on 2018/6/13.
//

import XCTest
@testable import JSON

final class JSONTests: XCTestCase {
    func testInitializers() {
        let string = "string"
        XCTAssertEqual(JSON(string), .string(string))

        XCTAssertEqual(JSON(42 as Int), .number(42))
        XCTAssertEqual(JSON(42 as Int8), .number(42))
        XCTAssertEqual(JSON(42 as Int16), .number(42))
        XCTAssertEqual(JSON(42 as Int32), .number(42))
        XCTAssertEqual(JSON(42 as Int64), .number(42))
        XCTAssertEqual(JSON(42 as UInt), .number(42))
        XCTAssertEqual(JSON(42 as UInt8), .number(42))
        XCTAssertEqual(JSON(42 as UInt16), .number(42))
        XCTAssertEqual(JSON(42 as UInt32), .number(42))
        XCTAssertEqual(JSON(42 as UInt64), .number(42))
        XCTAssertEqual(JSON(42 as Float), .number(42))
        XCTAssertEqual(JSON(42 as Double), .number(42))

        XCTAssertEqual(JSON(NSNumber(value: true)), .true)
        XCTAssertEqual(JSON(NSNumber(value: false)), .false)
        XCTAssertEqual(JSON(NSNumber(value: 1)), .number(1))
        XCTAssertEqual(JSON(NSNumber(value: 0)), .number(0))

        let object: [String: JSON] = [string: .string(string)]
        XCTAssertEqual(JSON(object), .object(object))

        let array: [JSON] = [.string(string), .object(object)]
        XCTAssertEqual(JSON(array), .array(array))

        XCTAssertEqual(JSON(NSNull()), .null)

        XCTAssertNil(JSON([string: NSObject()]))
        XCTAssertEqual(JSON([string: string]), .object(object))

        XCTAssertNil(JSON([NSObject()]))
        XCTAssertEqual(JSON([string, [string: string]]), .array(array))

        XCTAssertEqual(JSON(NSNumber(value: 42) as Any), .number(42))
        XCTAssertEqual(JSON(object as Any), .object(object))
        XCTAssertEqual(JSON(array as Any), .array(array))
        XCTAssertEqual(JSON(NSNull() as Any), .null)
        XCTAssertEqual(JSON(Optional<Any>.none as Any), .null)
    }
}
