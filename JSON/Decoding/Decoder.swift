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
            return try T(from: _Decoder(codingPath: [], userInfo: userInfo, value: value))
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
        guard !topValue.isNull else {
            let description = "Cannot get unkeyed decoding container -- found null value instead."
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
            throw DecodingError.valueNotFound(UnkeyedDecodingContainer.self, context)
        }
        guard let array = topValue.array else {
            throw DecodingError._typeMismatch(at: codingPath, expectation: [JSON].self, reality: topValue)
        }
        return JSON.UnkeyedDecodingContainer(codingPath: codingPath, decoder: self, array: array)
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return self
    }
}

// MARK: - Unboxing

extension JSON._Decoder {
    private func expectNonNull<T>(_ value: JSON, for type: T.Type) throws {
        guard !value.isNull else {
            let description = "Expected \(type) but found null value instead."
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
            throw DecodingError.valueNotFound(type, context)
        }
    }

    private func unbox<T: Numeric>(_ value: JSON, asNumberFitIn type: T.Type) throws -> T {
        try expectNonNull(value, for: type)
        guard let number = value.number else {
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: value)
        }
        guard let result = number as? T else {
            let description = "Parsed JSON number <\(number)> does not fit in \(type)."
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
            throw DecodingError.dataCorrupted(context)
        }
        return result
    }
}

extension JSON._Decoder {
    func unbox(_ value: JSON, as type: Bool.Type) throws -> Bool {
        try expectNonNull(value, for: type)
        guard let result = value.bool else {
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: value)
        }
        return result
    }

    func unbox(_ value: JSON, as type: Int.Type) throws -> Int { return try unbox(value, asNumberFitIn: type) }
    func unbox(_ value: JSON, as type: Int8.Type) throws -> Int8 { return try unbox(value, asNumberFitIn: type) }
    func unbox(_ value: JSON, as type: Int16.Type) throws -> Int16 { return try unbox(value, asNumberFitIn: type) }
    func unbox(_ value: JSON, as type: Int32.Type) throws -> Int32 { return try unbox(value, asNumberFitIn: type) }
    func unbox(_ value: JSON, as type: Int64.Type) throws -> Int64 { return try unbox(value, asNumberFitIn: type) }
    func unbox(_ value: JSON, as type: UInt.Type) throws -> UInt { return try unbox(value, asNumberFitIn: type) }
    func unbox(_ value: JSON, as type: UInt8.Type) throws -> UInt8 { return try unbox(value, asNumberFitIn: type) }
    func unbox(_ value: JSON, as type: UInt16.Type) throws -> UInt16 { return try unbox(value, asNumberFitIn: type) }
    func unbox(_ value: JSON, as type: UInt32.Type) throws -> UInt32 { return try unbox(value, asNumberFitIn: type) }
    func unbox(_ value: JSON, as type: UInt64.Type) throws -> UInt64 { return try unbox(value, asNumberFitIn: type) }
    func unbox(_ value: JSON, as type: Float.Type) throws -> Float { return try unbox(value, asNumberFitIn: type) }
    func unbox(_ value: JSON, as type: Double.Type) throws -> Double { return try unbox(value, asNumberFitIn: type) }

    func unbox(_ value: JSON, as type: String.Type) throws -> String {
        try expectNonNull(value, for: type)
        guard let result = value.string else {
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: value)
        }
        return result
    }

    func unbox<T: Decodable>(_ value: JSON, as type: T.Type) throws -> T {
        try expectNonNull(value, for: type)
        stroage.append(value)
        defer { stroage.removeLast() }
        return try T(from: self)
    }
}

// MARK: - SingleValueDecodingContainer

extension JSON._Decoder: SingleValueDecodingContainer {
    func decodeNil() -> Bool { return topValue.isNull }
    func decode(_ type: Bool.Type) throws -> Bool { return try unbox(topValue, as: type) }
    func decode(_ type: Int.Type) throws -> Int { return try unbox(topValue, as: type) }
    func decode(_ type: Int8.Type) throws -> Int8 { return try unbox(topValue, as: type) }
    func decode(_ type: Int16.Type) throws -> Int16 { return try unbox(topValue, as: type) }
    func decode(_ type: Int32.Type) throws -> Int32 { return try unbox(topValue, as: type) }
    func decode(_ type: Int64.Type) throws -> Int64 { return try unbox(topValue, as: type) }
    func decode(_ type: UInt.Type) throws -> UInt { return try unbox(topValue, as: type) }
    func decode(_ type: UInt8.Type) throws -> UInt8 { return try unbox(topValue, as: type) }
    func decode(_ type: UInt16.Type) throws -> UInt16 { return try unbox(topValue, as: type) }
    func decode(_ type: UInt32.Type) throws -> UInt32 { return try unbox(topValue, as: type) }
    func decode(_ type: UInt64.Type) throws -> UInt64 { return try unbox(topValue, as: type) }
    func decode(_ type: Float.Type) throws -> Float { return try unbox(topValue, as: type) }
    func decode(_ type: Double.Type) throws -> Double { return try unbox(topValue, as: type) }
    func decode(_ type: String.Type) throws -> String { return try unbox(topValue, as: type) }
    func decode<T: Decodable>(_ type: T.Type) throws -> T { return try unbox(topValue, as: type) }
}
