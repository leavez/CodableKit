//
//  URLDecodingStrategy.swift
//  JSONTests
//
//  Created by 李孛 on 2018/6/23.
//

import XCTest
@testable import JSON

final class URLDecodingStrategyTests: XCTestCase {
    func testDeferredToURL() {
        let options: JSON.Decoder.Options = {
            let decoder = JSON.Decoder()
            decoder.urlDecodingStrategy = .deferredToURL
            return decoder.options
        }()
        let decoder = JSON._Decoder(codingPath: [], options: options)
        decoder.stroage = ["https://json.org"]
        XCTAssertThrowsError(try decoder.decode(URL.self))
        XCTAssertThrowsError(try decoder.decode(URL?.self))
    }

    func testConvertFromString() {
        do {
            let options: JSON.Decoder.Options = {
                let decoder = JSON.Decoder()
                decoder.urlDecodingStrategy = .convertFromString(treatInvalidURLStringAsNull: false)
                return decoder.options
            }()
            let decoder = JSON._Decoder(codingPath: [], options: options)
            decoder.stroage = [""]
            XCTAssertThrowsError(try decoder.decode(URL.self))
            decoder.stroage = ["https://json.org"]
            XCTAssertEqual((try! decoder.decode(URL.self)).absoluteString, "https://json.org")
        }
        do {
            let options: JSON.Decoder.Options = {
                let decoder = JSON.Decoder()
                decoder.urlDecodingStrategy = .convertFromString(treatInvalidURLStringAsNull: true)
                return decoder.options
            }()
            let decoder = JSON._Decoder(codingPath: [], options: options)
            decoder.stroage = [nil]
            XCTAssertEqual(try! decoder.decode(URL?.self), nil)
            decoder.stroage = ["https://json.org"]
            XCTAssertEqual((try! decoder.decode(URL?.self))?.absoluteString, "https://json.org")
            decoder.stroage = [""]
            XCTAssertEqual(try! decoder.decode(URL?.self), nil)
        }
    }
}
