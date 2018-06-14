//
//  Decoder.swift
//  JSON
//
//  Created by 李孛 on 2018/6/14.
//

import Foundation

extension JSONDecoder {
    open func decode<T: Decodable>(_ type: T.Type, from json: JSON) throws -> T {
        let decoder = _JSONDecoder()
        decoder.stroage.append(json)
        return try T.init(from: decoder)
    }
}

class _JSONDecoder: Decoder {
    var stroage: [JSON] = []

    // MARK: - Decoder

    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey: Any] = [:]

    func container<Key: CodingKey>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> {
        guard let object = stroage.last?.object else {
            fatalError()
        }
        return KeyedDecodingContainer(_KeyedDecodingContainer(object: object, decoder: self, codingPath: codingPath))
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        guard let array = stroage.last?.array else {
            fatalError()
        }
        return _UnkeyedDecodingContainer(array: array, decoder: self, codingPath: codingPath)
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        guard let json = stroage.last else {
            fatalError()
        }
        return _SingleValueDecodingContainer(json: json, decoder: self, codingPath: codingPath)
    }
}
