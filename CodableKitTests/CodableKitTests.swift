//
//  CodableKitTests.swift
//  CodableKitTests
//
//  Created by 李孛 on 2018/6/26.
//

import XCTest
@testable import CodableKit

final class CodableKitTests: XCTestCase {
    let data = """
        {
            "id": "0",
            "nested": {
                "string": "string"
            }
        }
        """
        .data(using: .utf8)!

    func testKeyedDecodingContainerProtocol() {
        struct Model: Decodable {
            let id: String
            let data: String?
            let index: Int

            enum CodingKeys: CodingKey {
                case id
                case data
                case index
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                id = try container.decode(.id)
                data = try container.decodeIfPresent(.data)
                index = container[.index] ?? 0
            }
        }

        let model = try! JSONDecoder().decode(Model.self, from: data)

        XCTAssertEqual(model.id, "0")
        XCTAssertNil(model.data)
        XCTAssertEqual(model.index, 0)
    }

    func testAnyCodingKey() {
        do {
            let key = AnyCodingKey(stringValue: "key")
            XCTAssertEqual(key.stringValue, "key")
            XCTAssertNil(key.intValue)
        }
        do {
            let key = AnyCodingKey(intValue: 0)
            XCTAssertEqual(key.stringValue, "0")
            XCTAssertEqual(key.intValue, 0)
        }
        do {
            let key: AnyCodingKey = "key"
            XCTAssertEqual(key.stringValue, "key")
            XCTAssertNil(key.intValue)
        }

        struct Model: Decodable {
            let id: String
            let data: String?
            let index: Int
            let nestedString: String

            init(from decoder: Decoder) throws {
                let container = try decoder.container()
                id = try container.decode("id")
                data = try container.decodeIfPresent("data")
                index = container["index"] ?? 0
                let nestedContainer = try container.nestedContainer(forKey: "nested")
                nestedString = try nestedContainer.decode("string")
            }
        }

        let model = try! JSONDecoder().decode(Model.self, from: data)

        XCTAssertEqual(model.id, "0")
        XCTAssertNil(model.data)
        XCTAssertEqual(model.index, 0)
        XCTAssertEqual(model.nestedString, "string")
    }
}
