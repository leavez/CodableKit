//
//  DateDecodingStrategyTests.swift
//  CodableKit
//
//  Created by 李孛 on 2018/7/1.
//

import XCTest
@testable import CodableKit

final class DateDecodingStrategyTests: XCTestCase {
    func testDeferredToDate() {
        let options: JSON.Decoder.Options = {
            let decoder = JSON.Decoder()
            decoder.dateDecodingStrategy = .deferredToDate
            return decoder.options
        }()
        let decoder = JSON._Decoder(codingPath: [], options: options)
        decoder.stroage = [0]
        XCTAssertEqual(try! decoder.decode(Date.self), Date(timeIntervalSinceReferenceDate: 0))
    }

    func testSecondsSince1970() {
        let options: JSON.Decoder.Options = {
            let decoder = JSON.Decoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            return decoder.options
        }()
        let decoder = JSON._Decoder(codingPath: [], options: options)
        decoder.stroage = [0]
        XCTAssertEqual(try! decoder.decode(Date.self), Date(timeIntervalSince1970: 0))
    }

    func testMillisecondsSince1970() {
        let options: JSON.Decoder.Options = {
            let decoder = JSON.Decoder()
            decoder.dateDecodingStrategy = .millisecondsSince1970
            return decoder.options
        }()
        let decoder = JSON._Decoder(codingPath: [], options: options)
        decoder.stroage = [42000]
        XCTAssertEqual(try! decoder.decode(Date.self), Date(timeIntervalSince1970: 42))
    }
}
