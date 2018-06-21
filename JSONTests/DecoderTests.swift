//
//  DecoderTests.swift
//  JSONTests
//
//  Created by 李孛 on 2018/6/21.
//

import XCTest
@testable import JSON

final class DecoderTests: XCTestCase {
    struct Model: Codable, Equatable {
        let string: String
        let number: Int
        let array: [Model]?
    }

    func test() {
        let decoder = JSON.Decoder()
        let data = """
            {
                "string": "libei",
                "number": 42
            }
            """
            .data(using: .utf8)!
        let model = Model(string: "libei", number: 42, array: nil)
        let decodedModel = try! decoder.decode(Model.self, from: data)
        XCTAssertEqual(model, decodedModel)
    }
}
