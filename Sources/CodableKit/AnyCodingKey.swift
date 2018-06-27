//
//  AnyCodingKey.swift
//  CodableKit
//
//  Created by 李孛 on 2018/6/20.
//

public struct AnyCodingKey: CodingKey {
    public let stringValue: String
    public let intValue: Int?

    public init(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }

    public init(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }

    init(index: Int) {
        self.stringValue = "Index \(index)"
        self.intValue = index
    }

    static let `super` = AnyCodingKey(stringValue: "super")
}

extension AnyCodingKey: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(stringValue: value)
    }
}

extension Decoder {
    public func container() throws -> KeyedDecodingContainer<AnyCodingKey> {
        return try container(keyedBy: AnyCodingKey.self)
    }
}

extension KeyedDecodingContainerProtocol {
    public func nestedContainer(forKey key: Key) throws -> KeyedDecodingContainer<AnyCodingKey> {
        return try nestedContainer(keyedBy: AnyCodingKey.self, forKey: key)
    }
}
