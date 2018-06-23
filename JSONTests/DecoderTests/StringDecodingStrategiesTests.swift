//
//  StringDecodingStrategiesTests.swift
//  JSONTests
//
//  Created by 李孛 on 2018/6/23.
//

import XCTest
@testable import JSON

final class StringDecodingStrategiesTests: XCTestCase {
    func testConvertFromNumber() {
        let options: JSON.Decoder.Options = {
            let decoder = JSON.Decoder()
            decoder.stringDecodingStrategies = [.convertFromNumber]
            return decoder.options
        }()
        let decoder = JSON._Decoder(codingPath: [], options: options)
        XCTAssertEqual(try! decoder.unbox(42, as: String.self), "42")
    }

    func testConvertFromTrue() {
        let options: JSON.Decoder.Options = {
            let decoder = JSON.Decoder()
            decoder.stringDecodingStrategies = [.convertFromTrue]
            return decoder.options
        }()
        let decoder = JSON._Decoder(codingPath: [], options: options)
        XCTAssertEqual(try! decoder.unbox(true, as: String.self), "true")
    }

    func testConvertFromFalse() {
        let options: JSON.Decoder.Options = {
            let decoder = JSON.Decoder()
            decoder.stringDecodingStrategies = [.convertFromFalse]
            return decoder.options
        }()
        let decoder = JSON._Decoder(codingPath: [], options: options)
        XCTAssertEqual(try! decoder.unbox(false, as: String.self), "false")
    }
}
