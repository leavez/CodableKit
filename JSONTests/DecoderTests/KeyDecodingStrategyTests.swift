//
//  KeyDecodingStrategyTests.swift
//  JSONTests
//
//  Created by 李孛 on 2018/6/24.
//

import XCTest
@testable import JSON

final class KeyDecodingStrategyTests: XCTestCase {
    func testConvertFromSnakeCase() {
        let options: JSON.Decoder.Options = {
            let decoder = JSON.Decoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder.options
        }()
        let decoder = JSON._Decoder(codingPath: [], options: options)
        decoder.stroage = [["answer_id": "42"]]
        enum CodingKeys: String, CodingKey { case answerID }
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        XCTAssertEqual(try! container.decode(String.self, forKey: .answerID), "42")
    }
}
