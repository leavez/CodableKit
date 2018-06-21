//
//  Decoder.swift
//  JSON
//
//  Created by 李孛 on 2018/6/15.
//

import Foundation

extension JSON {
    /// An object that decodes instances of a data type from `JSON`.
    open class Decoder {
        public enum KeyDecodingStrategy {
            case useDefaultKey
            case convertFromSnakeCase
            case custom((_ codingPath: [CodingKey]) -> CodingKey)
        }

        open var keyDecodingStrategy: KeyDecodingStrategy = .useDefaultKey

        struct Options {
            let keyDecodingStrategy: KeyDecodingStrategy
            let userInfo: [CodingUserInfoKey: Any]
        }

        var options: Options {
            return Options(keyDecodingStrategy: keyDecodingStrategy, userInfo: userInfo)
        }

        /// A dictionary you use to customize the decoding process by providing contextual information.
        open var userInfo: [CodingUserInfoKey: Any] = [:]

        public init() {}

        /// Returns a value of the type you specify, decoded from a `JSON` value.
        ///
        /// - Parameters:
        ///   - type: The type of the value to decode from the supplied `JSON` value.
        ///   - value: The `JSON` value to decode.
        open func decode<T: Decodable>(_ type: T.Type, from value: JSON) throws -> T {
            let decoder = _Decoder(codingPath: [], options: options)
            return try decoder.unbox(value, as: type)
        }

        open func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
            let json = try Serialization.json(with: data)
            return try decode(type, from: json)
        }
    }

    final class _Decoder {
        var codingPath: [CodingKey]
        var stroage: [JSON] = []
        let options: Decoder.Options

        var userInfo: [CodingUserInfoKey: Any] {
            return options.userInfo
        }

        var topValue: JSON {
            precondition(!stroage.isEmpty)
            return stroage.last!
        }

        init(codingPath: [CodingKey], options: Decoder.Options) {
            self.codingPath = codingPath
            self.options = options
        }
    }
}

extension JSON._Decoder: Decoder {
    func container<Key: CodingKey>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> {
        try expectNonNull(topValue, for: KeyedDecodingContainer<Key>.self)
        guard let object = topValue.object else {
            throw DecodingError._typeMismatch(at: codingPath, expectation: [String: JSON].self, reality: topValue)
        }
        let container = JSON.KeyedDecodingContainer<Key>(codingPath: codingPath, decoder: self, object: object)
        return KeyedDecodingContainer(container)
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        try expectNonNull(topValue, for: UnkeyedDecodingContainer.self)
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
            let description = "Expected \(type) but found null instead."
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
            throw DecodingError.valueNotFound(type, context)
        }
    }

    private func unbox<T: Numeric>(_ value: JSON, asNumberFitIn type: T.Type) throws -> T {
        try expectNonNull(value, for: type)
        guard let number = value.number else {
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: value)
        }
        // `number as? T` is actually `T(exactly:)`.
        //
        // https://github.com/apple/swift/blob/master/stdlib/public/SDK/Foundation/NSNumber.swift
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
