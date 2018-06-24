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
            decoder.urlDecodingStrategy = .convertFromString(treatInvalidURLStringAsNull: true)
            return decoder.options
        }()
        let decoder = JSON._Decoder(codingPath: [], options: options)
        decoder.stroage = [["json_org_url": "https://json.org"]]
        enum CodingKeys: String, CodingKey { case jsonOrgURL }
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        XCTAssertEqual((try! container.decode(URL.self, forKey: .jsonOrgURL)).absoluteString, "https://json.org")
    }
}
