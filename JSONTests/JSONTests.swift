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
        let data = """
            {
                "string": "string",
                "number": 42,
                "object": {
                    "string": "string",
                    "number": -42
                },
                "array": [
                    "string",
                    42.0,
                    {
                        "string": "string",
                        "number": -42.0
                    },
                    ["string", 0],
                    true,
                    false,
                    null
                ],
                "true": true,
                "false": false,
                "null": null
            }
            """
            .data(using: .utf8)!
        let jsonObject = try! JSONSerialization.jsonObject(with: data)
        _ = JSON(jsonObject)!
    }

    func testDecoder() {
        struct Model: Decodable {
            let string: String
            let number: Int
            let array: [Int]
            let bool: Bool
            let null: Int?
        }
        let json: JSON = [
            "string": "string",
            "number": 42,
            "array": [1, 2, 3, 4],
            "bool": true,
            "null": nil
        ]
        let model = try! JSON.Decoder().decode(Model.self, from: json)
        print("\(json)")
    }
}
