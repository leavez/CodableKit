//
//  JSONTests.swift
//  JSONTests
//
//  Created by 李孛 on 2018/6/13.
//

import XCTest
@testable import JSON

class JSONTests: XCTestCase {
    func test() {
        let anyJSON = AnyJSON(["a": 1])!
        print(anyJSON)
    }
}
