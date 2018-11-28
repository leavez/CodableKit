//
//  AutoConvertible_TypeConvertion_Test.swift
//  CodableKitTests
//
//  Created by leave on 2018/11/28.
//

import XCTest
import CodableKit
#if canImport(CoreGraphics)
import CoreGraphics
#endif

class AutoConvertible_TypeConvertion_Test: XCTestCase {

    func testInt() {
        
        class IntTypesModel: Decodable {
            
            let int: Int
            let int8: Int8
            let int16: Int16
            let int32: Int32
            let int64: Int64
            let uInt: UInt
            let uInt8: UInt8
            let uInt16: UInt16
            let uInt32: UInt32
            let uInt64: UInt64
            
            required init(from decoder: Decoder) throws {
                let map = try decoder.container().makeCompatible
                int = try map.decode("int")
                int8 = try map.decode("short")
                int16 = try map.decode("int")
                int32 = try map.decode("int")
                int64 = try map.decode("long")
                uInt = try map.decode("uint")
                uInt8 = try map.decode("short")
                uInt16 = try map.decode("uint")
                uInt32 = try map.decode("uint")
                uInt64 = try map.decode("long")
            }
        }
        let json = """
{
    "short": 123,
    "int": 12345,
    "uint": 12345,
    "long": 1234567891011121314
}
""".data(using: .utf8)!
        do{
            let a = try JSONDecoder().decode(IntTypesModel.self, from: json)
            XCTAssertEqual(a.int, 12345)
            XCTAssertEqual(a.int8, 123)
            XCTAssertEqual(a.int16, 12345)
            XCTAssertEqual(a.int32, 12345)
            XCTAssertEqual(a.int64, 1234567891011121314)
            XCTAssertEqual(a.uInt, 12345)
            XCTAssertEqual(a.uInt8, 123)
            XCTAssertEqual(a.uInt16, 12345)
            XCTAssertEqual(a.uInt32, 12345)
            XCTAssertEqual(a.uInt64, 1234567891011121314)
        } catch let e {
            XCTFail(e.localizedDescription)
        }
        
        let json2 = """
{
    "short": "123",
    "int": "-12345",
    "uint": "12345",
    "long": "1234567891011121314"
}
""".data(using: .utf8)!
        do{
            let a = try JSONDecoder().decode(IntTypesModel.self, from: json2)
            XCTAssertEqual(a.int, -12345)
            XCTAssertEqual(a.int8, 123)
            XCTAssertEqual(a.int16, -12345)
            XCTAssertEqual(a.int32, -12345)
            XCTAssertEqual(a.int64, 1234567891011121314)
            XCTAssertEqual(a.uInt, 12345)
            XCTAssertEqual(a.uInt8, 123)
            XCTAssertEqual(a.uInt16, 12345)
            XCTAssertEqual(a.uInt32, 12345)
            XCTAssertEqual(a.uInt64, 1234567891011121314)
        } catch let e {
            XCTFail(e.localizedDescription)
        }
        
        let json3 = """
{
    "short": "123.1444",
    "int": "-12345.123",
    "uint": "12345.1123",
    "long": "1234567891011121314.123"
}
""".data(using: .utf8)!
        do{
            let a = try JSONDecoder().decode(IntTypesModel.self, from: json3)
            XCTAssertEqual(a.int, -12345)
            XCTAssertEqual(a.int8, 123)
            XCTAssertEqual(a.int16, -12345)
            XCTAssertEqual(a.int32, -12345)
            XCTAssertEqual(a.int64, 1234567891011121314)
            XCTAssertEqual(a.uInt, 12345)
            XCTAssertEqual(a.uInt8, 123)
            XCTAssertEqual(a.uInt16, 12345)
            XCTAssertEqual(a.uInt32, 12345)
            XCTAssertEqual(a.uInt64, 1234567891011121314)
        } catch let e {
            XCTFail(e.localizedDescription)
        }
    }



    func testFloat() {
        
        class FloatTypesModel: Decodable {
            
            let double: Double
            let float: Float
            #if canImport(CoreGraphics)
            let cgFloat: CGFloat
            #endif
            
            required init(from decoder: Decoder) throws {
                let map = try decoder.container().makeCompatible
                double = try map.decode("double")
                float = try map.decode("double")
                #if canImport(CoreGraphics)
                cgFloat = try map.decode("double")
                #endif
            }
        }
        do{
            let a = try JSONDecoder().decode(FloatTypesModel.self, from: jsonData(object:  ["double": "-12345.123"]))
            XCTAssertEqual(a.double, -12345.123)
            XCTAssertEqual(a.float, -12345.123)
            #if canImport(CoreGraphics)
            XCTAssertEqual(a.cgFloat, -12345.123)
            #endif
        } catch let e {
            XCTFail(e.localizedDescription)
        }

        XCTAssertEqual(try? JSONDecoder().decode(FloatTypesModel.self, from: jsonData(object: ["double": 1.0])).double, 1)
        XCTAssertEqual(try? JSONDecoder().decode(FloatTypesModel.self, from: jsonData(object: ["double": 1.01])).double, 1.01)
        XCTAssertEqual(try? JSONDecoder().decode(FloatTypesModel.self, from: jsonData(object: ["double": "1.01"])).double, 1.01)
        XCTAssertEqual(try? JSONDecoder().decode(FloatTypesModel.self, from: jsonData(object: ["double": "-1.01"])).double, -1.01)
        XCTAssertEqual(try? JSONDecoder().decode(FloatTypesModel.self, from: jsonData(object: ["double": "0"])).double, 0)
        XCTAssertThrowsError(try JSONDecoder().decode(FloatTypesModel.self, from: jsonData(object: ["double": "aaa"])))
    }




    func testBool() {
        
        struct BoolModel: Decodable {
            let bool: Bool
            init(from decoder: Decoder) throws {
                let map = try decoder.container().makeCompatible
                bool = try map.decode("bool")
            }
        }
        func generateBoolModel(JSONObject: Any) throws -> BoolModel {
            return try JSONDecoder().decode(BoolModel.self, from: jsonData(object: JSONObject))
        }
        XCTAssertEqual(try? generateBoolModel(JSONObject: ["bool": 0]).bool, false)
        XCTAssertEqual(try? generateBoolModel(JSONObject: ["bool": -1]).bool, true)
        XCTAssertEqual(try? generateBoolModel(JSONObject: ["bool": 1]).bool, true)
        XCTAssertEqual(try? generateBoolModel(JSONObject: ["bool": 9999]).bool, true)
        XCTAssertEqual(try? generateBoolModel(JSONObject: ["bool": "YES"]).bool, true)
        XCTAssertEqual(try? generateBoolModel(JSONObject: ["bool": "True"]).bool, true)
        XCTAssertEqual(try? generateBoolModel(JSONObject: ["bool": "true"]).bool, true)
        XCTAssertEqual(try? generateBoolModel(JSONObject: ["bool": "TRUE"]).bool, true)
        XCTAssertEqual(try? generateBoolModel(JSONObject: ["bool": "1"]).bool, true)
        XCTAssertEqual(try? generateBoolModel(JSONObject: ["bool": "NO"]).bool, false)
        XCTAssertEqual(try? generateBoolModel(JSONObject: ["bool": "False"]).bool, false)
        XCTAssertEqual(try? generateBoolModel(JSONObject: ["bool": "FALSE"]).bool, false)
        XCTAssertEqual(try? generateBoolModel(JSONObject: ["bool": "false"]).bool, false)
        XCTAssertEqual(try? generateBoolModel(JSONObject: ["bool": "0"]).bool, false)

        XCTAssertThrowsError(try generateBoolModel(JSONObject: ["bool": "aaa"]).bool)
        XCTAssertThrowsError(try generateBoolModel(JSONObject: ["bool": 12.34]).bool)
        XCTAssertThrowsError(try generateBoolModel(JSONObject: ["bool": "2"]).bool)
    }




    func testString() {
        struct StringModel: Decodable {
            let value: String
            init(from decoder: Decoder) throws {
                let map = try decoder.container().makeCompatible
                value = try map.decode("value")
            }
        }
        func generateStringModel(JSONObject: Any) throws -> StringModel {
            return try JSONDecoder().decode(StringModel.self, from: jsonData(object: JSONObject))
        }
        
        XCTAssertEqual(try? generateStringModel(JSONObject: ["value": "ssss"]).value, "ssss")
        XCTAssertEqual(try? generateStringModel(JSONObject: ["value": 0]).value, "0")
        XCTAssertEqual(try? generateStringModel(JSONObject: ["value": 123]).value, "123")
        XCTAssertEqual(try? generateStringModel(JSONObject: ["value": -1]).value, "-1")
        XCTAssertEqual(try? generateStringModel(JSONObject: ["value": 123.0]).value, "123")
        XCTAssertEqual(try? generateStringModel(JSONObject: ["value": 123.456]).value, "123.456")
        XCTAssertEqual(try? generateStringModel(JSONObject: ["value": -123.456]).value, "-123.456")
        XCTAssertEqual(try? generateStringModel(JSONObject: ["value": true]).value, "true")
        
        XCTAssertThrowsError(try generateStringModel(JSONObject: ["value": []]).value)
        XCTAssertThrowsError(try generateStringModel(JSONObject: ["value": [:]]).value)
    }
    
}


func jsonData(object:Any) -> Data {
    return try! JSONSerialization.data(withJSONObject: object, options: [])
}
