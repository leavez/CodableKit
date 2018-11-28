//
//  AutoConvertible_Tests.swift
//  CodableKitTests
//
//  Created by leave on 2018/11/28.
//

import XCTest
import CodableKit

class AutoConvertible_Tests: XCTestCase {
    
    
    // MARK:- keyed
    
    

    func test_keyedDecodeAutoConvert() throws {
        let jsonData = """
        {
            "a": "1",
            "b": 123
        }
        """.data(using: .utf8)!
        
        struct Model: Decodable {
            let a: Int
            let b: String
            init(from decoder: Decoder) throws {
                let c = try decoder.container().makeCompatible
                try a = c.decode("a")
                try b = c.decode("b")
            }
        }
        
        let m = try! JSONDecoder().decode(Model.self, from: jsonData)
        XCTAssertEqual(m.a, 1)
        XCTAssertEqual(m.b, "123")
    }
    
    func test_keyedDecodeAutoConvert_stillThrowIfVeryBadType() throws {
        
        struct Model: Decodable {
            let a: Int
            init(from decoder: Decoder) throws {
                let c = try decoder.container().makeCompatible
                try a = c.decode("a")
            }
        }
        
        let jsonData = """
        {
            "a": {},
        }
        """.data(using: .utf8)!
        
        XCTAssertThrowsError( try JSONDecoder().decode(Model.self, from: jsonData) )
    }
    
    func test_keyedDecodeAutoConvert_DoNotAffectOriginalCode() throws {
        
        let jsonData = """
        {
            "a": "1",
            "b": 123
        }
        """.data(using: .utf8)!
        
        struct OriginalModel: Decodable {
            let a: Int
            let b: String
            init(from decoder: Decoder) throws {
                let c = try decoder.container()
                try a = c.decode("a")
                try b = c.decode("b")
            }
        }
        XCTAssertThrowsError( try JSONDecoder().decode(OriginalModel.self, from: jsonData) )
        
        enum PlainType: Int, Codable {
            case p1, p2
        }
        struct A: Codable {
            let a: PlainType
        }
        let data = """
            {"a":1}
        """.data(using: .utf8)!
        let m = try JSONDecoder().decode(A.self, from: data)
        XCTAssertEqual(m.a, .p2)
    }
    
    
    
    
    // MARK:- Unkeyed
    

    func test_UnkeyedDecodeAutoConvert() throws {
        let jsonData = """
        {
            "a": ["1", 123]
        }
        """.data(using: .utf8)!
        struct Model: Decodable {
            let a: Int
            let b: String
            init(from decoder: Decoder) throws {
                var c = try decoder.container().nestedUnkeyedContainer(forKey: "a").makeCompatible
                try a = c.decode(Int.self)
                try b = c.decode(String.self)
            }
        }
        
        let m = try! JSONDecoder().decode(Model.self, from: jsonData)
        XCTAssertEqual(m.a, 1)
        XCTAssertEqual(m.b, "123")
    }
    
    func test_unkeyedDecodeAutoConvert_stillThrowIfVeryBadType() throws {
        
        struct Model: Decodable {
            let a: Int
            init(from decoder: Decoder) throws {
                var c = try decoder.container().nestedUnkeyedContainer(forKey: "a").makeCompatible
                try a = c.decode(Int.self)
            }
        }
        
        let jsonData = """
        {
            "a": [{}],
        }
        """.data(using: .utf8)!
        
        XCTAssertThrowsError( try JSONDecoder().decode(Model.self, from: jsonData) )
    }
    
    func test_unkeyedDecodeAutoConvert_DoNotAffectOriginalCode() throws {
        
        let jsonData = """
        {
            "a": ["1", 123]
        }
        """.data(using: .utf8)!
        struct OriginalModel: Decodable {
            let a: Int
            let b: String
            init(from decoder: Decoder) throws {
                var c = try decoder.container().nestedUnkeyedContainer(forKey: "a")
                try a = c.decode(Int.self)
                try b = c.decode(String.self)
            }
        }
        do {
           _ = try JSONDecoder().decode(OriginalModel.self, from: jsonData)
        } catch DecodingError.typeMismatch(let t, _) {
            XCTAssertTrue(t == Int.self)
        }
        
        enum PlainType: Int, Codable {
            case p1, p2
        }
        struct A: Codable {
            let a: [PlainType]
        }
        let data = """
            {"a":[1]}
        """.data(using: .utf8)!
        let m = try JSONDecoder().decode(A.self, from: data)
        XCTAssertEqual(m.a, [.p2])
    }
    
}
