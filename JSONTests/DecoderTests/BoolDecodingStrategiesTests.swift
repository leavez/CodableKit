//
//  BoolDecodingStrategiesTests.swift
//  JSONTests
//
//  Created by 李孛 on 2018/6/23.
//

import XCTest
@testable import JSON

final class BoolDecodingStrategiesTests: XCTestCase {
    func testConvertFromString() {
        let options: JSON.Decoder.Options = {
            let decoder = JSON.Decoder()
            decoder.boolDecodingStrategies = [.convertFromString]
            return decoder.options
        }()
        let decoder = JSON._Decoder(codingPath: [], options: options)
        XCTAssertEqual(try! decoder.unbox("true", as: Bool.self), true)
        XCTAssertEqual(try! decoder.unbox("false", as: Bool.self), false)
    }

    func testConvertFromNumber() {
        let options: JSON.Decoder.Options = {
            let decoder = JSON.Decoder()
            decoder.boolDecodingStrategies = [.convertFromNumber]
            return decoder.options
        }()
        let decoder = JSON._Decoder(codingPath: [], options: options)
        XCTAssertEqual(try! decoder.unbox(1, as: Bool.self), true)
        XCTAssertEqual(try! decoder.unbox(0, as: Bool.self), false)
        XCTAssertEqual(try! decoder.unbox(-1, as: Bool.self), true)
    }
}
