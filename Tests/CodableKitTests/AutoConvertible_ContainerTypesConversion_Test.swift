//
//  AutoConvertible_OptionalConversion_Test.swift
//  CodableKitTests
//
//  Created by leave on 2018/11/29.
//

import XCTest
import CodableKit

class AutoConvertible_OptionalConversion_Test: XCTestCase {

    func test_Array() {
        struct A: Decodable {
            let a: [Int]
            init(from decoder: Decoder) throws {
                let container = try decoder.container().compatible()
                try a = container.decode("a")
            }
        }
        
        let data = """
        { "a" : ["123", 456, "7", 8] }
        """.data(using: .utf8)!
        let model = try! JSONDecoder().decode(A.self, from: data)
        XCTAssertEqual(model.a, [123, 456, 7, 8])
    }
    
    func test_Dict() {
        struct A: Decodable {
            let a: [String: Int]
            init(from decoder: Decoder) throws {
                let container = try decoder.container().compatible()
                try a = container.decode("a")
            }
        }
        
        let data = """
        {
            "a" : {"hello": "123", "world": 456}
        }
        """.data(using: .utf8)!
        let model = try! JSONDecoder().decode(A.self, from: data)
        XCTAssertEqual(model.a, ["hello": 123, "world": 456])
    }
    
    func test_OptionalShouldReturnNilIfMisType() {
        struct A: Decodable {
            let a: Int?
            init(from decoder: Decoder) throws {
                let container = try decoder.container().compatible()
                try a = container.decode("a")
            }
        }
        
        let data = """
        { "a" : [] }
        """.data(using: .utf8)!
        let model = try! JSONDecoder().decode(A.self, from: data)
        XCTAssertEqual(model.a, nil)
    }
    
    func test_Set() {
        struct A: Decodable {
            let a: Set<Int>
            init(from decoder: Decoder) throws {
                let container = try decoder.container().compatible()
                try a = container.decode("a")
            }
        }
        
        let data = """
        { "a" : ["123", 456, "7", 8] }
        """.data(using: .utf8)!
        let model = try! JSONDecoder().decode(A.self, from: data)
        XCTAssertEqual(model.a, Set([123, 456, 7, 8]))
    }
    
    func test_ArrarInUnkeyedContainer() {
        struct A: Decodable {
            let a: [Int]
            init(from decoder: Decoder) throws {
                let container = try decoder.container().compatible()
                var unkeyedContainer = try container.nestedUnkeyedContainer(forKey: "a").compatible()
                let  _ : Int = try unkeyedContainer.decode(Int.self)
                a = try unkeyedContainer.decode([Int].self)
            }
        }
        
        let data = """
        { "a" : [0, ["123", 456, "7", 8]] }
        """.data(using: .utf8)!
        let model = try! JSONDecoder().decode(A.self, from: data)
        XCTAssertEqual(model.a, [123, 456, 7, 8])
    }
}
