//
//  _Decoder.swift
//  CodableKit
//
//  Created by 李孛 on 2018/6/23.
//

import Foundation

extension JSON {
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
        case let (.string(string), strategies) where strategies.contains(.convertFromString):
            guard let number = NumberFormatter().number(from: string) else {
                throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: value)
            }
            return try unbox(number, as: type)
        case let (.number(number), _):
            return try unbox(number, as: type)
        case let (.true, strategies) where strategies.contains(.convertFromBoolean):
            return 1
        case let (.false, strategies) where strategies.contains(.convertFromBoolean):
            return 0
        default:
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: value)
        }
    }
}

extension JSON._Decoder {
    func unbox(_ value: JSON, as type: Bool.Type) throws -> Bool {
        try expectNonNull(value, for: type)
        switch (value, options.booleanDecodingStrategies) {
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
        case let (.string(string), _):
            return string
        case let (.number(number), strategies) where strategies.contains(.convertFromNumber):
            return number.stringValue
        case let (.true, strategies) where strategies.contains(.convertFromBoolean):
            return "true"
        case let (.false, strategies) where strategies.contains(.convertFromBoolean):
            return "false"
        default:
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: value)
        }
    }

    func unbox(_ value: JSON, as type: Date.Type) throws -> Date {
        try expectNonNull(value, for: type)
        switch options.dateDecodingStrategy {
        case .deferredToDate:
            stroage.append(value)
            defer { stroage.removeLast() }
            return try Date(from: self)
        case .secondsSince1970:
            let timeInterval = try unbox(value, as: TimeInterval.self)
            return Date(timeIntervalSince1970: timeInterval)
        case .millisecondsSince1970:
            let timeInterval = try unbox(value, as: TimeInterval.self)
            return Date(timeIntervalSince1970: timeInterval / 1000)
        }
    }

    func unbox(_ value: JSON, as type: URL.Type) throws -> URL {
        try expectNonNull(value, for: type)
        switch options.urlDecodingStrategy {
        case .deferredToURL:
            stroage.append(value)
            defer { stroage.removeLast() }
            return try URL(from: self)
        case .convertFromString:
            let string = try unbox(value, as: String.self)
            guard let url = URL(string: string) else {
                let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Invalid URL string.")
                throw DecodingError.dataCorrupted(context)
            }
            return url
        }
    }

    func unbox<T: Decodable>(_ value: JSON, as type: T.Type) throws -> T {
        // Can't use switch in here.
        if type is Date.Type { // NSDate is not Decodable.
            return try unbox(value, as: Date.self) as! T
        } else if type is URL.Type || type is NSURL.Type {
            return try unbox(value, as: URL.self) as! T
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
