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
}
