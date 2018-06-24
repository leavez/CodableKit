//
//  Tests.swift
//  JSONTests
//
//  Created by 李孛 on 2018/6/24.
//

import XCTest
@testable import JSON

final class Tests: XCTestCase {
    func test() {
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
