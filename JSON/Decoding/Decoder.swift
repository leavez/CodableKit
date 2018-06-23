//
//  Decoder.swift
//  JSON
//
//  Created by 李孛 on 2018/6/15.
//

import Foundation

extension JSON {

    // MARK: - JSON.Decoder

    /// An object that decodes instances of a data type from `JSON`.
    open class Decoder {
        public struct StringDecodingStrategies: OptionSet {
            public static let convertFromNumber = StringDecodingStrategies(rawValue: 1 << 0)
            public static let convertFromTrue = StringDecodingStrategies(rawValue: 1 << 1)
            public static let convertFromFalse = StringDecodingStrategies(rawValue: 1 << 2)

            public let rawValue: Int
            public init(rawValue: Int) { self.rawValue = rawValue }
        }

        public struct NumberDecodingStrategies: OptionSet {
            public static let convertFromString = NumberDecodingStrategies(rawValue: 1 << 0)
            public static let convertFromTrue = NumberDecodingStrategies(rawValue: 1 << 1)
            public static let convertFromFalse = NumberDecodingStrategies(rawValue: 1 << 2)

            public let rawValue: Int
            public init(rawValue: Int) { self.rawValue = rawValue }
        }

        public struct BoolDecodingStrategies: OptionSet {
            public static let convertFromString = BoolDecodingStrategies(rawValue: 1 << 0)
            public static let convertFromNumber = BoolDecodingStrategies(rawValue: 1 << 1)

            public var trueConvertibleStrings: Set<String> = ["true"]
            public var falseConvertibleStrings: Set<String> = ["false"]

            public let rawValue: Int
            public init(rawValue: Int) { self.rawValue = rawValue }
        }

        public enum URLDecodingStrategy {
            case deferredToURL
            case convertFromString(treatInvalidURLStringAsNull: Bool)
        }

        struct Options {
            let stringDecodingStrategies: StringDecodingStrategies
            let numberDecodingStrategies: NumberDecodingStrategies
            let boolDecodingStrategies: BoolDecodingStrategies
            let urlDecodingStrategy: URLDecodingStrategy
            let userInfo: [CodingUserInfoKey: Any]
        }

        open var stringDecodingStrategies: StringDecodingStrategies = []
        open var numberDecodingStrategies: NumberDecodingStrategies = []
        open var boolDecodingStrategies: BoolDecodingStrategies = []
        open var urlDecodingStrategy: URLDecodingStrategy = .deferredToURL

        var options: Options {
            return Options(stringDecodingStrategies: stringDecodingStrategies,
                           numberDecodingStrategies: numberDecodingStrategies,
                           boolDecodingStrategies: boolDecodingStrategies,
                           urlDecodingStrategy: urlDecodingStrategy,
                           userInfo: userInfo)
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

    // MARK: - JSON._Decoder

    final class _Decoder {
        var codingPath: [CodingKey]

        let options: Decoder.Options
        var userInfo: [CodingUserInfoKey: Any] {
            return options.userInfo
        }

        var stroage: [JSON] = []
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

// MARK: Swift.Decoder

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

// MARK: Unboxing

extension JSON._Decoder {
    private func expectNonNull<T>(_ value: JSON, for type: T.Type) throws {
        guard !value.isNull else {
            let description = "Expected \(type) but found null instead."
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
            throw DecodingError.valueNotFound(type, context)
        }
    }

    private func unbox<T: Numeric>(_ number: NSNumber, as type: T.Type) throws -> T {
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

    private func unbox<T: Numeric>(_ value: JSON, asNumberFitIn type: T.Type) throws -> T {
        try expectNonNull(value, for: type)
        switch (value, options.numberDecodingStrategies) {
        case (.string(let string), let strategies) where strategies.contains(.convertFromString):
            guard let number = NumberFormatter().number(from: string) else {
                throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: value)
            }
            return try unbox(number, as: type)
        case (.number(let number), _):
            return try unbox(number, as: type)
        case (.true, let strategies) where strategies.contains(.convertFromTrue):
            return 1
        case (.false, let strategies) where strategies.contains(.convertFromFalse):
            return 0
        default:
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: value)
        }
    }
}

extension JSON._Decoder {
    func unbox(_ value: JSON, as type: Bool.Type) throws -> Bool {
        try expectNonNull(value, for: type)
        switch (value, options.boolDecodingStrategies) {
        case let (.string(string), strategies)
            where strategies.contains(.convertFromString) && strategies.trueConvertibleStrings.contains(string):
            return true
        case let (.string(string), strategies)
            where strategies.contains(.convertFromString) && strategies.falseConvertibleStrings.contains(string):
            return false
        case let (.number(number), strategies) where strategies.contains(.convertFromNumber):
            return number != 0
        case (.true, _):
            return true
        case (.false, _):
            return false
        default:
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: value)
        }
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
        switch (value, options.stringDecodingStrategies) {
        case (.string(let string), _):
            return string
        case (.number(let number), let strategies) where strategies.contains(.convertFromNumber):
            return number.stringValue
        case (.true, let strategies) where strategies.contains(.convertFromTrue):
            return "true"
        case (.false, let strategies) where strategies.contains(.convertFromFalse):
            return "false"
        default:
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: value)
        }
    }

    func unbox(_ value: JSON, as type: URL.Type) throws -> URL {
        try expectNonNull(value, for: type)
        let string = try unbox(value, as: String.self)
        guard let url = URL(string: string) else {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Invalid URL string.")
            throw DecodingError.dataCorrupted(context)
        }
        return url
    }

    func unbox(_ value: JSON, as type: URL?.Type) throws -> URL? {
        if value.isNull {
            return nil
        }
        let string = try unbox(value, as: String.self)
        if let url = URL(string: string) {
            return url
        }
        return nil
    }

    func unbox<T: Decodable>(_ value: JSON, as type: T.Type) throws -> T {
        if case .convertFromString = options.urlDecodingStrategy, type is URL.Type || type is NSURL.Type {
            return try unbox(value, as: URL.self) as! T
        }
        if case let .convertFromString(treatInvalidURLStringAsNull) = options.urlDecodingStrategy,
            treatInvalidURLStringAsNull, type is URL?.Type || type is NSURL?.Type {
            return try unbox(value, as: URL?.self) as! T
        }
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
