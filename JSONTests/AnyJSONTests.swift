//
//  AnyJSONTests.swift
//  JSONTests
//
//  Created by 李孛 on 2018/6/13.
//

import XCTest
@testable import JSON

class AnyJSONTests: XCTestCase {

    func testObject() {
        let _: AnyJSON = [:]
        let _: AnyJSON = ["1": 1]
        let _: AnyJSON = [
            "1": 1,
            "2": "2",
        ]
        let _: AnyJSON = [
            "1": 1,
            "2": "2",
            "3": [3],
            "4": ["4": 4],
        ]
    }

    func testArray() {
        let _: AnyJSON = []
        let _: AnyJSON = [1]
        let _: AnyJSON = [1, "2"]
        let _: AnyJSON = [1, "2", [3]]
        let _: AnyJSON = [1, "2", [3], ["4": 4]]
    }

    func testValue() {
        let _: AnyJSON = true
        let _: AnyJSON = false
        let _: AnyJSON = nil
    }

    func testString() {
        let _: AnyJSON = ""
    }

    func testNumber() {
        let _: AnyJSON = 0
        let _: AnyJSON = 0.0
    }

}
