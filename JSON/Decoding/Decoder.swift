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
        open var keyDecodingStrategy: KeyDecodingStrategy
        open var stringDecodingStrategies: StringDecodingStrategies
        open var numberDecodingStrategies: NumberDecodingStrategies
        open var boolDecodingStrategies: BoolDecodingStrategies
        open var urlDecodingStrategy: URLDecodingStrategy

        /// A dictionary you use to customize the decoding process by providing contextual information.
        open var userInfo: [CodingUserInfoKey: Any] = [:]

        var options: Options {
            return Options(keyDecodingStrategy: keyDecodingStrategy,
                           stringDecodingStrategies: stringDecodingStrategies,
                           numberDecodingStrategies: numberDecodingStrategies,
                           boolDecodingStrategies: boolDecodingStrategies,
                           urlDecodingStrategy: urlDecodingStrategy,
                           userInfo: userInfo)
        }

        public init(options: Options = .default) {
            keyDecodingStrategy = options.keyDecodingStrategy
            stringDecodingStrategies = options.stringDecodingStrategies
            numberDecodingStrategies = options.numberDecodingStrategies
            boolDecodingStrategies = options.boolDecodingStrategies
            urlDecodingStrategy = options.urlDecodingStrategy
        }

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

        open func decode<T: Decodable>(_ type: T.Type, from value: Any) throws -> T {
            switch value {
            case let json as JSON:
                return try decode(type, from: json)
            case let data as Data:
                return try decode(type, from: data)
            default:
                guard let json = JSON(value) else {
                    let description = "The given value was not valid JSON."
                    let context = DecodingError.Context(codingPath: [], debugDescription: description)
                    throw DecodingError.dataCorrupted(context)
                }
                return try decode(type, from: json)
            }
        }
    }
}

extension JSON.Decoder {
    public enum KeyDecodingStrategy {
        case useDefaultKeys
        case convertFromSnakeCase
    }

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

    public struct Options {
        public static var `default` = Options(keyDecodingStrategy: .useDefaultKeys,
                                              stringDecodingStrategies: [],
                                              numberDecodingStrategies: [],
                                              boolDecodingStrategies: [],
                                              urlDecodingStrategy: .deferredToURL,
                                              userInfo: [:])

        public var keyDecodingStrategy: KeyDecodingStrategy
        public var stringDecodingStrategies: StringDecodingStrategies
        public var numberDecodingStrategies: NumberDecodingStrategies
        public var boolDecodingStrategies: BoolDecodingStrategies
        public var urlDecodingStrategy: URLDecodingStrategy
        let userInfo: [CodingUserInfoKey: Any]
    }
}
