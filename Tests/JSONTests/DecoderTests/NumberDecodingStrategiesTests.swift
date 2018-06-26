//
//  NumberDecodingStrategiesTests.swift
//  JSONTests
//
//  Created by 李孛 on 2018/6/23.
//

import XCTest
@testable import CodableKit

final class NumberDecodingStrategiesTests: XCTestCase {
    func testConvertFromString() {
        let options: JSON.Decoder.Options = {
            let decoder = JSON.Decoder()
            decoder.numberDecodingStrategies = [.convertFromString]
            return decoder.options
        }()
        let decoder = JSON._Decoder(codingPath: [], options: options)
        XCTAssertThrowsError(try decoder.unbox("string", as: Int.self))
        XCTAssertEqual(try! decoder.unbox("42", as: Int.self), 42)
    }

    func testConvertFromTrue() {
        let options: JSON.Decoder.Options = {
            let decoder = JSON.Decoder()
            decoder.numberDecodingStrategies = [.convertFromBoolean]
            return decoder.options
        }()
        let decoder = JSON._Decoder(codingPath: [], options: options)
        XCTAssertEqual(try! decoder.unbox(true, as: Int.self), 1)
        XCTAssertEqual(try! decoder.unbox(false, as: Int.self), 0)
    }
}
