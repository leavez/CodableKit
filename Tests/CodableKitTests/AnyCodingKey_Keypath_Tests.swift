//
//  AnyCodingKey_Keypath_Tests.swift
//  CodableKitTests
//
//  Created by leave on 2018/11/27.
//

import XCTest
@testable import CodableKit

class AnyCodingKey_Keypath_Tests: XCTestCase {

    func test_keyPath_decoding() {
        struct Model: Decodable {
            let a: Int
            let value1: Int
            let value2: [Int]
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container()
                a = try container.decode("a")
                value1 = try container.decode("b0.b1.value")
                value2 = try container.decode("c0.c1")
            }
        }
        let data = """
            {
                "a": 1,
                "b0": {
                    "b1": {
                        "value" : 233
                    }
                },
                "c0": {
                    "c1": [1,2]
                }
            }
            """.data(using: .utf8)!
        do {
            let m = try JSONDecoder().decode(Model.self, from: data)
            XCTAssertEqual(m.a, 1)
            XCTAssertEqual(m.value1, 233)
            XCTAssertEqual(m.value2, [1,2])
        } catch let e {
            XCTFail("\(e)")
        }
    }
    
    func test_keyPath_Encoding() {
        struct Model: Encodable {
            let a: Int
            let value1: Int
            let value2: [Int]
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.container()
                try container.encode(a, forKeyPath: "a")
                try container.encode(value1, forKeyPath: "b0.b1.value")
                try container.encode(value2, forKeyPath: "c0.c1")
            }
        }
        let rawDict: NSDictionary = [
            "a": 1,
            "b0": [
                "b1": [
                    "value" : 233
                ]
            ],
            "c0": [
                "c1": [1,2]
            ]
        ]
        do {
            let data = try JSONEncoder().encode(Model(a: 1, value1: 233, value2: [1,2]))
            let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
            XCTAssertEqual(dict, rawDict)
        } catch let e {
            XCTFail("\(e)")
        }
    }
}
