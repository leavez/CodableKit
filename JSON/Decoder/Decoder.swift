//
//  Decoder.swift
//  JSON
//
//  Created by 李孛 on 2018/6/15.
//

extension JSON {
    open class Decoder {
        open func decode<T: Decodable>(_ type: T.Type, from json: JSON) throws -> T {
            let decoder = _Decoder()
            decoder.stroage.append(json)
            return try T.init(from: decoder)
        }
    }
}

final class _Decoder: Decoder {
    var stroage: [JSON] = []

    // MARK: Decoder

    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey: Any] = [:]

    func container<Key: CodingKey>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> {
        guard let value = stroage.last else { fatalError() }
        switch value {
        case .object(let object):
            return KeyedDecodingContainer(_KeyedDecodingContainer(codingPath: codingPath,
                                                                  decoder: self,
                                                                  object: object))
        default:
            fatalError()
        }
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        guard let value = stroage.last else { fatalError() }
        switch value {
        case .array(let array):
            return _UnkeyedDecodingContainer(codingPath: codingPath, decoder: self, array: array)
        default:
            fatalError()
        }
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        guard let value = stroage.last else { fatalError() }
        return _SingleValueDecodingContainer(codingPath: codingPath, decoder: self, value: value)
    }
}
