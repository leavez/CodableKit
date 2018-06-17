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
            let decoder = _Decoder(value: value, codingPath: [], userInfo: userInfo)
            return try T.init(from: decoder)
        }
    }

    final class _Decoder: Swift.Decoder {
        var stroage: [JSON] = []
        var topValue: JSON {
            precondition(!stroage.isEmpty)
            return stroage.last!
        }

        init(value: JSON, codingPath: [CodingKey], userInfo: [CodingUserInfoKey: Any]) {
            stroage.append(value)
            self.codingPath = codingPath
            self.userInfo = userInfo
        }

        var codingPath: [CodingKey]
        let userInfo: [CodingUserInfoKey: Any]

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
            return self
        }
    }
}

// MARK: - Unboxing

extension JSON._Decoder {
    func expectNonNull<T>(value: JSON, for type: T.Type) throws {
        guard !value.isNull else {
            let description = "Expected \(type) but found null value instead."
            throw DecodingError.valueNotFound(type,
                                              DecodingError.Context(codingPath: codingPath,
                                                                    debugDescription: description))
        }
    }

    func unbox(_ value: JSON, as type: Bool.Type) throws -> Bool {
        try expectNonNull(value: value, for: type)
        switch value {
        case .true:
            return true
        case .false:
            return false
        default:
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: value)
        }
    }

    func unbox(_ value: JSON, as type: Int.Type) throws -> Int {
        try expectNonNull(value: value, for: type)
        switch value {
        case .number(let number):
            if let number = number as? Int {
                return number
            } else {
                let description = "Parsed JSON number <\(number)> does not fit in \(type)."
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath,
                                                                        debugDescription: description))
            }
        default :
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: value)
        }
    }

    func unbox(_ value: JSON, as type: Int8.Type) throws -> Int8 {
        try expectNonNull(value: value, for: type)
        switch value {
        case .number(let number):
            if let number = number as? Int8 {
                return number
            } else {
                let description = "Parsed JSON number <\(number)> does not fit in \(type)."
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath,
                                                                        debugDescription: description))
            }
        default :
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: value)
        }
    }

    func unbox(_ value: JSON, as type: Int16.Type) throws -> Int16 {
        try expectNonNull(value: value, for: type)
        switch value {
        case .number(let number):
            if let number = number as? Int16 {
                return number
            } else {
                let description = "Parsed JSON number <\(number)> does not fit in \(type)."
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath,
                                                                        debugDescription: description))
            }
        default :
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: value)
        }
    }

    func unbox(_ value: JSON, as type: Int32.Type) throws -> Int32 {
        try expectNonNull(value: value, for: type)
        switch value {
        case .number(let number):
            if let number = number as? Int32 {
                return number
            } else {
                let description = "Parsed JSON number <\(number)> does not fit in \(type)."
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath,
                                                                        debugDescription: description))
            }
        default :
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: value)
        }
    }

    func unbox(_ value: JSON, as type: Int64.Type) throws -> Int64 {
        try expectNonNull(value: value, for: type)
        switch value {
        case .number(let number):
            if let number = number as? Int64 {
                return number
            } else {
                let description = "Parsed JSON number <\(number)> does not fit in \(type)."
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath,
                                                                        debugDescription: description))
            }
        default :
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: value)
        }
    }

    func unbox(_ value: JSON, as type: UInt.Type) throws -> UInt {
        try expectNonNull(value: value, for: type)
        switch value {
        case .number(let number):
            if let number = number as? UInt {
                return number
            } else {
                let description = "Parsed JSON number <\(number)> does not fit in \(type)."
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath,
                                                                        debugDescription: description))
            }
        default :
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: value)
        }
    }

    func unbox(_ value: JSON, as type: UInt8.Type) throws -> UInt8 {
        try expectNonNull(value: value, for: type)
        switch value {
        case .number(let number):
            if let number = number as? UInt8 {
                return number
            } else {
                let description = "Parsed JSON number <\(number)> does not fit in \(type)."
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath,
                                                                        debugDescription: description))
            }
        default :
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: value)
        }
    }

    func unbox(_ value: JSON, as type: UInt16.Type) throws -> UInt16 {
        try expectNonNull(value: value, for: type)
        switch value {
        case .number(let number):
            if let number = number as? UInt16 {
                return number
            } else {
                let description = "Parsed JSON number <\(number)> does not fit in \(type)."
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath,
                                                                        debugDescription: description))
            }
        default :
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: value)
        }
    }

    func unbox(_ value: JSON, as type: UInt32.Type) throws -> UInt32 {
        try expectNonNull(value: value, for: type)
        switch value {
        case .number(let number):
            if let number = number as? UInt32 {
                return number
            } else {
                let description = "Parsed JSON number <\(number)> does not fit in \(type)."
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath,
                                                                        debugDescription: description))
            }
        default :
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: value)
        }
    }

    func unbox(_ value: JSON, as type: UInt64.Type) throws -> UInt64 {
        try expectNonNull(value: value, for: type)
        switch value {
        case .number(let number):
            if let number = number as? UInt64 {
                return number
            } else {
                let description = "Parsed JSON number <\(number)> does not fit in \(type)."
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath,
                                                                        debugDescription: description))
            }
        default :
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: value)
        }
    }

    func unbox(_ value: JSON, as type: Float.Type) throws -> Float {
        try expectNonNull(value: value, for: type)
        switch value {
        case .number(let number):
            if let number = number as? Float {
                return number
            } else {
                let description = "Parsed JSON number <\(number)> does not fit in \(type)."
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath,
                                                                        debugDescription: description))
            }
        default :
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: value)
        }
    }

    func unbox(_ value: JSON, as type: Double.Type) throws -> Double {
        try expectNonNull(value: value, for: type)
        switch value {
        case .number(let number):
            if let number = number as? Double {
                return number
            } else {
                let description = "Parsed JSON number <\(number)> does not fit in \(type)."
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath,
                                                                        debugDescription: description))
            }
        default :
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: value)
        }
    }

    func unbox(_ value: JSON, as type: String.Type) throws -> String {
        try expectNonNull(value: value, for: type)
        switch value {
        case .string(let string):
            return string
        default :
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: value)
        }
    }

    func unbox<T: Decodable>(_ value: JSON, as type: T.Type) throws -> T {
        try expectNonNull(value: value, for: type)
        stroage.append(value)
        defer { stroage.removeLast() }
        return try T(from: self)
    }
}

// MARK: - SingleValueDecodingContainer

extension JSON._Decoder: SingleValueDecodingContainer {
    func decodeNil() -> Bool { return topValue.isNull }
    func decode(_ type: Bool.Type)   throws -> Bool   { return try unbox(topValue, as: type) }
    func decode(_ type: Int.Type)    throws -> Int    { return try unbox(topValue, as: type) }
    func decode(_ type: Int8.Type)   throws -> Int8   { return try unbox(topValue, as: type) }
    func decode(_ type: Int16.Type)  throws -> Int16  { return try unbox(topValue, as: type) }
    func decode(_ type: Int32.Type)  throws -> Int32  { return try unbox(topValue, as: type) }
    func decode(_ type: Int64.Type)  throws -> Int64  { return try unbox(topValue, as: type) }
    func decode(_ type: UInt.Type)   throws -> UInt   { return try unbox(topValue, as: type) }
    func decode(_ type: UInt8.Type)  throws -> UInt8  { return try unbox(topValue, as: type) }
    func decode(_ type: UInt16.Type) throws -> UInt16 { return try unbox(topValue, as: type) }
    func decode(_ type: UInt32.Type) throws -> UInt32 { return try unbox(topValue, as: type) }
    func decode(_ type: UInt64.Type) throws -> UInt64 { return try unbox(topValue, as: type) }
    func decode(_ type: Float.Type)  throws -> Float  { return try unbox(topValue, as: type) }
    func decode(_ type: Double.Type) throws -> Double { return try unbox(topValue, as: type) }
    func decode(_ type: String.Type) throws -> String { return try unbox(topValue, as: type) }
    func decode<T: Decodable>(_ type: T.Type) throws -> T { return try unbox(topValue, as: type) }
}
