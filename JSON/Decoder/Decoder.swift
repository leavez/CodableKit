//
//  Decoder.swift
//  JSON
//
//  Created by 李孛 on 2018/6/15.
//

extension JSON {
    /// An object that decodes instances of a data type from `JSON`.
    open class Decoder {
        /// A dictionary you use to customize the decoding process by providing contextual information.
        open var userInfo: [CodingUserInfoKey: Any] = [:]

        /// Returns a value of the type you specify, decoded from a `JSON` value.
        ///
        /// - Parameters:
        ///   - type: The type of the value to decode from the supplied `JSON` value.
        ///   - value: The `JSON` value to decode.
        open func decode<T: Decodable>(_ type: T.Type, from value: JSON) throws -> T {
            let decoder = _Decoder(codingPath: [], userInfo: userInfo, value: value)
            return try T(from: decoder)
        }
    }

    final class _Decoder {
        var codingPath: [CodingKey]
        let userInfo: [CodingUserInfoKey: Any]
        var stroage: [JSON] = []

        var topValue: JSON {
            precondition(!stroage.isEmpty)
            return stroage.last!
        }

        init(codingPath: [CodingKey], userInfo: [CodingUserInfoKey: Any], value: JSON) {
            self.codingPath = codingPath
            self.userInfo = userInfo
            stroage.append(value)
        }
    }
}

extension JSON._Decoder: Decoder {
    func container<Key: CodingKey>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> {
        guard !topValue.isNull else {
            let description = "Cannot get keyed decoding container -- found null value instead."
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
            throw DecodingError.valueNotFound(KeyedDecodingContainer<Key>.self, context)
        }
        guard let object = topValue.object else {
            throw DecodingError._typeMismatch(at: codingPath, expectation: [String: JSON].self, reality: topValue)
        }
        let container = JSON.KeyedDecodingContainer<Key>(codingPath: codingPath, decoder: self, object: object)
        return KeyedDecodingContainer(container)
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        switch topValue {
        case .array(let array):
            return JSON.UnkeyedDecodingContainer(codingPath: codingPath, decoder: self, array: array)
        case .null:
            let description = "Cannot get unkeyed decoding container -- found null value instead."
            throw DecodingError.valueNotFound(UnkeyedDecodingContainer.self,
                                              DecodingError.Context(codingPath: codingPath,
                                                                    debugDescription: description))
        default:
            throw DecodingError._typeMismatch(at: codingPath, expectation: [JSON].self, reality: topValue)
        }
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return self
    }
}
