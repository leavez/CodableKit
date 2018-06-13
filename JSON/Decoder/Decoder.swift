//
//  Decoder.swift
//  JSON
//
//  Created by 李孛 on 2018/6/13.
//

import Foundation

extension JSONDecoder {
    open func decode<T: Decodable>(_ type: T.Type, from json: JSON) throws -> T {
        return try T.init(from: _JSONDecoder(json: json))
    }
}

class _JSONDecoder: Decoder {
    var stroage: [JSON] = []

    init(json: JSON) {
        stroage.append(json)
    }

    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey: Any] = [:]

    func container<Key: CodingKey>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> {
        fatalError()
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        guard let json = stroage.last else {
            // FIXME:
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        return _UnkeyedDecodingContainer(json: json, decoder: self, codingPath: codingPath)
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        guard let json = stroage.last else {
            // FIXME:
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        return _SingleValueDecodingContainer(json: json, decoder: self, codingPath: codingPath)
    }
}
