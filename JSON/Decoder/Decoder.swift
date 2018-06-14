//
//  Decoder.swift
//  JSON
//
//  Created by 李孛 on 2018/6/14.
//

import Foundation

open class Decoder {
    open func decode<T: Decodable>(_ type: T.Type, from json: JSON) throws -> T {
        let decoder = _Decoder()
        decoder.stroage.append(json)
        return try T.init(from: decoder)
    }
}

final class _Decoder: Swift.Decoder {
    var stroage: [JSON] = []

    // MARK: - Decoder

    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey: Any] = [:]

    func container<Key: CodingKey>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> {
        guard let object = stroage.last?.object else {
            throw DecodingError._typeMismatch(at: codingPath,
                                              expectation: Object.self,
                                              reality: stroage.last as Any)
        }
        return KeyedDecodingContainer(_KeyedDecodingContainer(object: object, decoder: self, codingPath: codingPath))
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        guard let array = stroage.last?.array else {
            throw DecodingError._typeMismatch(at: codingPath,
                                              expectation: Array.self,
                                              reality: stroage.last as Any)
        }
        return _UnkeyedDecodingContainer(array: array, decoder: self, codingPath: codingPath)
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        guard let json = stroage.last else {
            throw DecodingError._typeMismatch(at: codingPath, expectation: JSON.self, reality: stroage.last as Any)
        }
        return _SingleValueDecodingContainer(json: json, decoder: self, codingPath: codingPath)
    }
}

// MARK: -

extension DecodingError {
    static func _typeMismatch(at path: [CodingKey], expectation: Any.Type, reality: Any) -> DecodingError {
        let description = "Expected to decode \(expectation) but found \(reality) instead."
        return .typeMismatch(expectation, Context(codingPath: path, debugDescription: description))
    }
}
