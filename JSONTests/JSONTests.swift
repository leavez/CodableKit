//
//  JSONTests.swift
//  JSONTests
//
//  Created by 李孛 on 2018/6/13.
//

import XCTest
@testable import JSON

class JSONTests: XCTestCase {
    func testJSON() {
        var json: JSON
        // object
        json = ["key": "value"]
        XCTAssert(json.object?["key"]?.string == "value")
        json = ["key": 42.0]
        XCTAssert(json.object?["key"]?.number == 42)
        // array
        json = ["value"]
        XCTAssert(json.array?[0].string == "value")
        // true
        json = true
        XCTAssert(json.trueOrFalse == true)
        json = NSNumber(value: true)
        XCTAssert(json.trueOrFalse == true)
        // false
        json = false
        XCTAssert(json.trueOrFalse == false)
        json = NSNumber(value: false)
        XCTAssert(json.trueOrFalse == false)
        // null
        json = Optional<Bool>.none
        XCTAssert(json.isNull)
        json = NSNull()
        XCTAssert(json.isNull)
        // string
        json = "string"
        XCTAssert(json.string == "string")
        // number
        json = 42.0
        XCTAssert(json.number == 42)
    }

    func testAnyJSON() {
        var json: AnyJSON
        // object
        json = ["null": nil, "true": true, "number": 42]
        XCTAssert(json.object?["null"]?.isNull == true)
        XCTAssert(json.object?["not_null"]?.isNull == nil)
        XCTAssert(json.object?["true"]?.trueOrFalse == true)
        XCTAssert(json.object?["number"]?.number == 42.0)
        json = [
            "object": ["number": 42.0, "string": "string"],
            "array": [1, nil, "string"],
        ]
        XCTAssert(json.object?["object"]?.object?["number"]?.number == 42)
        XCTAssert(json.object?["object"]?.object?["string"]?.string == "string")
        XCTAssert(json.object?["array"]?.array?[0].number == 1.0)
        XCTAssert(json.object?["array"]?.array?[1].isNull == true)
        // array
        json = ["null", nil, true, 42]
        XCTAssert(json.array?[0].isNull == false)
        XCTAssert(json.array?[1].isNull == true)
        XCTAssert(json.array?[2].trueOrFalse == true)
        XCTAssert(json.array?[3].number == 42)
        // true
        json = true
        XCTAssert(json.trueOrFalse == true)
        json = AnyJSON(NSNumber(value: true))
        XCTAssert(json.trueOrFalse == true)
        // false
        json = false
        XCTAssert(json.trueOrFalse == false)
        json = AnyJSON(NSNumber(value: false))
        XCTAssert(json.trueOrFalse == false)
        // null
        json = nil
        XCTAssert(json.isNull == true)
        json = AnyJSON(NSNull())
        XCTAssert(json.isNull == true)
        // string
        json = "string"
        XCTAssert(json.string == "string")
        // number
        json = 42
        XCTAssert(json.number == 42.0)
        json = 0.01
        XCTAssert(json.number == 0.01)
    }
}
