//
//  URLDecodingStrategy.swift
//  JSONTests
//
//  Created by 李孛 on 2018/6/23.
//

import XCTest
@testable import JSON

final class URLDecodingStrategyTests: XCTestCase {
    func testConvertFromString() {
        let options: JSON.Decoder.Options = {
            let decoder = JSON.Decoder()
            decoder.urlDecodingStrategy = .convertFromString(treatInvalidURLStringAsNull: true)
            return decoder.options
        }()
        let decoder = JSON._Decoder(codingPath: [], options: options)
        let urlString = "https://json.org"
        decoder.stroage = [JSON(urlString)]
        XCTAssertEqual(try! decoder.decode(URL.self), URL(string: urlString))
        decoder.stroage = [""]
        XCTAssertEqual(try! decoder.decode(URL?.self), nil)
    }
}
