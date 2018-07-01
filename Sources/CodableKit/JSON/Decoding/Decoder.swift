//
//  Decoder.swift
//  CodableKit
//
//  Created by 李孛 on 2018/6/15.
//

import Foundation

extension JSON {
    /// `JSON.Decoder` facilitates the decoding of JSON into semantic `Decodable` types.
    open class Decoder {
        /// The strategy to use for decoding keys.
        open var keyDecodingStrategy: KeyDecodingStrategy

        /// The strategy to use in decoding strings.
        open var stringDecodingStrategies: StringDecodingStrategies

        /// The strategy to use in decoding numbers.
        open var numberDecodingStrategies: NumberDecodingStrategies

        /// The strategy to use in decoding booleans.
        open var booleanDecodingStrategies: BooleanDecodingStrategies

        /// The strategy to use in decoding dates.
        open var dateDecodingStrategy: DateDecodingStrategy

        /// The strategy to use in decoding URLs.
        open var urlDecodingStrategy: URLDecodingStrategy

        /// Contextual user-provided information for use during decoding.
        open var userInfo: [CodingUserInfoKey: Any] = [:]

        /// The options set on the top-level decoder.
        var options: Options {
            return Options(keyDecodingStrategy: keyDecodingStrategy,
                           stringDecodingStrategies: stringDecodingStrategies,
                           numberDecodingStrategies: numberDecodingStrategies,
                           booleanDecodingStrategies: booleanDecodingStrategies,
                           dateDecodingStrategy: dateDecodingStrategy,
                           urlDecodingStrategy: urlDecodingStrategy,
                           userInfo: userInfo)
        }

        /// Initializes `self` with default strategies.
        public init(options: Options = .default) {
            keyDecodingStrategy = options.keyDecodingStrategy
            stringDecodingStrategies = options.stringDecodingStrategies
            numberDecodingStrategies = options.numberDecodingStrategies
            booleanDecodingStrategies = options.booleanDecodingStrategies
            dateDecodingStrategy = options.dateDecodingStrategy
            urlDecodingStrategy = options.urlDecodingStrategy
        }

        open func decode<T: Decodable>(_ type: T.Type, from value: JSON) throws -> T {
            let decoder = _Decoder(codingPath: [], options: options)
            return try decoder.unbox(value, as: type)
        }

        open func decode<T: Decodable>(_ type: T.Type, from value: [String: JSON]) throws -> T {
            return try decode(type, from: JSON(value))
        }

        open func decode<T: Decodable>(_ type: T.Type, from value: [JSON]) throws -> T {
            return try decode(type, from: JSON(value))
        }

        open func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
            let value = try Serialization.json(with: data)
            return try decode(type, from: value)
        }
    }
}

extension JSON.Decoder {
    /// The strategy to use for automatically changing the value of keys before decoding.
    public enum KeyDecodingStrategy {
        /// Use the keys specified by each type.
        case useDefaultKeys

        /// Convert from "snake_case_keys" to "camelCaseKeys" before attempting to match a key with the one specified by
        /// each type.
        case convertFromSnakeCase
    }

    /// The strategy to use for decoding `String` values.
    public struct StringDecodingStrategies: OptionSet {
        public static let convertFromNumber = StringDecodingStrategies(rawValue: 1 << 0)
        public static let convertFromBoolean = StringDecodingStrategies(rawValue: 1 << 1)

        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
    }

    /// The strategy to use for decoding number (`Int`, `UInt`, `Double`...) values.
    public struct NumberDecodingStrategies: OptionSet {
        public static let convertFromString = NumberDecodingStrategies(rawValue: 1 << 0)
        public static let convertFromBoolean = NumberDecodingStrategies(rawValue: 1 << 1)

        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
    }

    /// The strategy to use for decoding `Bool` values.
    public struct BooleanDecodingStrategies: OptionSet {
        public static let convertFromString = BooleanDecodingStrategies(rawValue: 1 << 0)
        public static let convertFromNumber = BooleanDecodingStrategies(rawValue: 1 << 1)

        public var trueConvertibleStrings: Set<String> = ["true"]
        public var falseConvertibleStrings: Set<String> = ["false"]

        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
    }

    /// The strategy to use for decoding `Date` values.
    public enum DateDecodingStrategy {
        /// Defer to `Date` for decoding.
        case deferredToDate

        /// Decode the `Date` as a UNIX timestamp from a JSON number.
        case secondsSince1970

        /// Decode the `Date` as UNIX millisecond timestamp from a JSON number.
        case millisecondsSince1970
    }

    /// The strategy to use for decoding `URL` values.
    public enum URLDecodingStrategy {
        /// Defer to `URL` for decoding.
        case deferredToURL
        case convertFromString(treatInvalidURLStringAsNull: Bool)
    }

    /// Options set on the top-level encoder to pass down the decoding hierarchy.
    public struct Options {
        public static var `default` = Options(
            keyDecodingStrategy: .useDefaultKeys,
            stringDecodingStrategies: [],
            numberDecodingStrategies: [],
            booleanDecodingStrategies: [],
            dateDecodingStrategy: .deferredToDate,
            urlDecodingStrategy: .convertFromString(treatInvalidURLStringAsNull: false),
            userInfo: [:]
        )

        public var keyDecodingStrategy: KeyDecodingStrategy
        public var stringDecodingStrategies: StringDecodingStrategies
        public var numberDecodingStrategies: NumberDecodingStrategies
        public var booleanDecodingStrategies: BooleanDecodingStrategies
        public var dateDecodingStrategy: DateDecodingStrategy
        public var urlDecodingStrategy: URLDecodingStrategy

        let userInfo: [CodingUserInfoKey: Any]
    }
}
