//
//  AnyCodingKeyTests.swift
//  CodableKitTests
//
//  Created by leave on 2018/11/27.
//

import XCTest
@testable import CodableKit

class AnyCodingKeyTests: XCTestCase {
    
    func test_initializer() {
        
        // test initializer
        do {
            let key = AnyCodingKey(stringValue: "key")
            XCTAssertEqual(key.stringValue, "key")
            XCTAssertNil(key.intValue)
        }
        do {
            let key = AnyCodingKey(intValue: 0)
            XCTAssertEqual(key.stringValue, "0")
            XCTAssertEqual(key.intValue, 0)
        }
        do {
            let key = AnyCodingKey(index: 0)
            XCTAssertEqual(key.stringValue, "Index 0")
            XCTAssertEqual(key.intValue, 0)
        }
        do {
            let key: AnyCodingKey = "key"
            XCTAssertEqual(key.stringValue, "key")
            XCTAssertNil(key.intValue)
        }
        
        // test all method could generate equal keys
        do {
            let text = "hello"
            let key1 = AnyCodingKey(stringValue: text)
            let key2 = AnyCodingKey(stringLiteral: text)
            let key3: AnyCodingKey = "hello"
            XCTAssertEqual(key1, key2)
            XCTAssertEqual(key2, key3)
        }
    }

    func test_decoding() {
        
        // test plain types
        do {
            struct Model: Decodable {
                let a: Int
                let b: String
                let c: Bool
                let d: Double
                let e: Double?
                
                init(from decoder: Decoder) throws {
                    let container = try decoder.container()
                    a = try container.decode(Int.self, forKey: "a")
                    b = try container.decode(String.self, forKey: "b")
                    c = try container.decode(Bool.self, forKey: "c")
                    d = try container.decode(Double.self, forKey: "d")
                    e = try container.decode(Double?.self, forKey: "e")
                }
            }
            let data = """
            {
                "a": 1,
                "b": "hello world",
                "c": true,
                "d": 1.23,
                "e": null
            }
            """.data(using: .utf8)!
            do {
                let m = try JSONDecoder().decode(Model.self, from: data)
                XCTAssertEqual(m.a, 1)
                XCTAssertEqual(m.b, "hello world")
                XCTAssertEqual(m.c, true)
                XCTAssertEqual(m.d, 1.23)
                XCTAssertEqual(m.e, nil)
            } catch let e {
                XCTFail("\(e)")
            }
        }
        
        // test nested types
        do {
            struct Inner: Decodable {
                let a: Int
            }
            struct Model: Decodable {
                let inner: Inner
                
                init(from decoder: Decoder) throws {
                    let container = try decoder.container()
                    inner = try container.decode(Inner.self, forKey: "inner")
                }
            }
            let data = """
            {
                "inner": {"a": 1}
            }
            """.data(using: .utf8)!
            do {
                let m = try JSONDecoder().decode(Model.self, from: data)
                XCTAssertEqual(m.inner.a, 1)
            } catch let e {
                XCTFail("\(e)")
            }
        }
        
        // test containers
        do {
            struct Model: Codable {
                let a: Int
                let b1: Int
                let b2: Int
                
                init(from decoder: Decoder) throws {
                    let container = try decoder.container()
                    let subContainer = try container.nestedContainer(forKey: "nested_container")
                    a = try subContainer.decode(Int.self, forKey: "a")
                    
                    var subUnkeyedContainer = try container.nestedUnkeyedContainer(forKey: "nested_unkeyed_container")
                    b1 = try subUnkeyedContainer.decode(Int.self)
                    b2 = try subUnkeyedContainer.decode(Int.self)
                }
            }
            
            let data = """
            {
                "nested_container": {
                    "a": 2
                },
                "nested_unkeyed_container": [1, 2]
            }
            """.data(using: .utf8)!
            do {
                let model = try JSONDecoder().decode(Model.self, from: data)
                XCTAssertEqual(model.a, 2)
                XCTAssertEqual(model.b1, 1)
                XCTAssertEqual(model.b2, 2)
            } catch let e {
                XCTFail("\(e)")
            }
        }
    }

    func test_encoding() {
        
        // test plain keys
        do {
            struct Model: Encodable {
                let a: Int
                let b: String
                let c: Bool
                let d: Double
                let e: Double?
                
                func encode(to encoder: Encoder) throws {
                    var container = encoder.container()
                    try container.encode(a, forKey: "a")
                    try container.encode(b, forKey: "b")
                    try container.encode(c, forKey: "c")
                    try container.encode(d, forKey: "d")
                    try container.encode(e, forKey: "e")
                }
            }
            do {
                let model = Model(a: 1, b: "hello world", c: true, d: 1.23, e: nil)
                let data = try JSONEncoder().encode(model)
                let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any?]
                XCTAssertEqual(dict["a"] as? Int, 1)
                XCTAssertEqual(dict["b"] as? String, "hello world")
                XCTAssertEqual(dict["c"] as? Bool, true)
                XCTAssertEqual(dict["d"] as? Double, 1.23)
                XCTAssertEqual(dict["e"] as? Double, nil)
            } catch let e {
                XCTFail("\(e)")
            }
        }
        
        // test nested types
        do {
            struct Inner: Encodable {
                let a: Int
            }
            struct Model: Encodable {
                let inner: Inner
                
                func encode(to encoder: Encoder) throws {
                    var container = encoder.container()
                    try container.encode(inner, forKey: "Inner")
                }
            }
            do {
                let data = try JSONEncoder().encode(Model(inner: Inner(a: 1)))
                let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
                XCTAssertEqual(dict, ["Inner": ["a": 1 ]])
            } catch let e {
                XCTFail("\(e)")
            }
        }
        
        // test containers
        do {
            struct Model: Encodable {
                let a: Int
                let b1: Int
                let b2: Int
                
                func encode(to encoder: Encoder) throws {
                    var container = encoder.container()
                    var subNestedContainer = container.nestedContainer(forKey: "nested_container")
                    try subNestedContainer.encode(a, forKey: "a")
                    var subUnkeyedContainer = container.nestedUnkeyedContainer(forKey: "nested_unkeyed_container")
                    try subUnkeyedContainer.encode(b1)
                    try subUnkeyedContainer.encode(b2)
                }
            }

            let rawData: NSDictionary =
            [
                "nested_container": [
                    "a": 2
                ],
                "nested_unkeyed_container": [1, 2]
            ]
            do {
                let model = Model(a: 2, b1: 1, b2: 2)
                let data = try JSONEncoder().encode(model)
                let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
                XCTAssertEqual(rawData, dict)
            } catch let e {
                XCTFail("\(e)")
            }
        }
    }

}

