//
//  BooleanDecodingStrategiesTests.swift
//  JSONTests
//
//  Created by 李孛 on 2018/6/23.
//

import XCTest
@testable import CodableKit

final class BooleanDecodingStrategiesTests: XCTestCase {
    func testConvertFromString() {
        let options: JSON.Decoder.Options = {
            let decoder = JSON.Decoder()
            decoder.booleanDecodingStrategies = [.convertFromString]
            return decoder.options
        }()
        let decoder = JSON._Decoder(codingPath: [], options: options)
        XCTAssertEqual(try! decoder.unbox("true", as: Bool.self), true)
        XCTAssertEqual(try! decoder.unbox("false", as: Bool.self), false)
    }

    func testConvertFromNumber() {
        let options: JSON.Decoder.Options = {
            let decoder = JSON.Decoder()
            decoder.booleanDecodingStrategies = [.convertFromNumber]
            return decoder.options
        }()
        let decoder = JSON._Decoder(codingPath: [], options: options)
        XCTAssertEqual(try! decoder.unbox(1, as: Bool.self), true)
        XCTAssertEqual(try! decoder.unbox(0, as: Bool.self), false)
        XCTAssertEqual(try! decoder.unbox(-1, as: Bool.self), true)
    }
}
