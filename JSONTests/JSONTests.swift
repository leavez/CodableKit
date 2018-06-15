//
//  JSONTests.swift
//  JSONTests
//
//  Created by 李孛 on 2018/6/13.
//

import XCTest
@testable import JSON

class JSONTests: XCTestCase {
    func testLiteral() {
        XCTAssert(JSON.string("string") == "string")
        XCTAssert(JSON.number(42) == 42.0)
        XCTAssert(JSON.object(["key": "value"]) == ["key": "value"])
        XCTAssert(JSON.array([1, 3, "5", 7.0]) == [1, 3, "5", 7.0])
        XCTAssert(JSON.true == true)
        XCTAssert(JSON.false == false)
        XCTAssert(JSON.null == nil)
    }

    func testConvenienceProperty() {
        let json: JSON = [
            "string": "string",
            "number": 42.0,
            "object": [
                "key": "value",
                "int": 42,
            ],
            "array": [1, 2, nil, "4", 5],
            "true": true,
            "false": false,
            "null": nil,
        ]
        XCTAssertNotNil(json.object)
        let object = json.object!
        XCTAssert(object["string"]?.string == "string")
        XCTAssert(object["number"]?.number == 42)
        XCTAssertNotNil(object["object"]?.object)
        XCTAssert(object["object"]!.object!["key"]?.string == "value")
        XCTAssert(object["object"]!.object!["int"] == 42)
        XCTAssert(object["array"]?.array?[0] == 1)
        XCTAssert(object["array"]?.array?[2] == nil as JSON)
        XCTAssert(object["array"]?.array?[2].isNull == true)
        XCTAssert(object["true"] == true)
        XCTAssert(object["false"] != true)
        XCTAssert(object["null"] == nil as JSON)
    }
}
