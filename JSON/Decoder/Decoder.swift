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
            let decoder = _Decoder(value: value)
            decoder.userInfo = userInfo
            return try T.init(from: decoder)
        }
    }

    final class _Decoder: Swift.Decoder {
        var stroage: [JSON] = []
        var topValue: JSON {
            precondition(!stroage.isEmpty)
            return stroage.last!
        }

        init(value: JSON) {
            stroage.append(value)
        }

        // MARK: Decoder

        var codingPath: [CodingKey] = []
        var userInfo: [CodingUserInfoKey: Any] = [:]

        func container<Key: CodingKey>(keyedBy type: Key.Type) throws -> Swift.KeyedDecodingContainer<Key> {
            switch topValue {
            case .object(let object):
                return Swift.KeyedDecodingContainer(KeyedDecodingContainer(codingPath: codingPath,
                                                                           decoder: self,
                                                                           object: object))
            case .null:
                let description = "Cannot get keyed decoding container -- found null value instead."
                throw DecodingError.valueNotFound(Swift.KeyedDecodingContainer<Key>.self,
                                                  DecodingError.Context(codingPath: codingPath,
                                                                        debugDescription: description))
            default:
                throw DecodingError._typeMismatch(at: codingPath, expectation: [String: JSON].self, reality: topValue)
            }
        }

        func unkeyedContainer() throws -> Swift.UnkeyedDecodingContainer {
            switch topValue {
            case .array(let array):
                return UnkeyedDecodingContainer(codingPath: codingPath, decoder: self, array: array)
            case .null:
                let description = "Cannot get unkeyed decoding container -- found null value instead."
                throw DecodingError.valueNotFound(Swift.UnkeyedDecodingContainer.self,
                                                  DecodingError.Context(codingPath: codingPath,
                                                                        debugDescription: description))
            default:
                throw DecodingError._typeMismatch(at: codingPath, expectation: [JSON].self, reality: topValue)
            }
        }

        func singleValueContainer() throws -> Swift.SingleValueDecodingContainer {
            return SingleValueDecodingContainer(codingPath: codingPath, decoder: self, value: topValue)
        }
    }
}

extension DecodingError {
    static func _typeMismatch(at path: [CodingKey], expectation: Any.Type, reality: Any) -> DecodingError {
        let description = "Expected to decode \(expectation) but found \(reality) instead."
        return .typeMismatch(expectation, Context(codingPath: path, debugDescription: description))
    }
}
