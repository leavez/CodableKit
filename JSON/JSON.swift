//
//  JSON.swift
//  JSON
//
//  Created by 李孛 on 2018/6/15.
//

import Foundation

/// JSON value.
///
/// [https://json.org](https://json.org)
public enum JSON: Equatable {
    case string(String)
    case number(NSNumber)
    case object([String: JSON])
    case array([JSON])
    case `true`
    case `false`
    case null
}

// MARK: - Initializers

extension JSON {
    public init(_ string: String) { self = .string(string) }
    public init(_ number: Int) { self = .number(number as NSNumber) }
    public init(_ number: Int8) { self = .number(number as NSNumber) }
    public init(_ number: Int16) { self = .number(number as NSNumber) }
    public init(_ number: Int32) { self = .number(number as NSNumber) }
    public init(_ number: Int64) { self = .number(number as NSNumber) }
    public init(_ number: UInt) { self = .number(number as NSNumber) }
    public init(_ number: UInt8) { self = .number(number as NSNumber) }
    public init(_ number: UInt16) { self = .number(number as NSNumber) }
    public init(_ number: UInt32) { self = .number(number as NSNumber) }
    public init(_ number: UInt64) { self = .number(number as NSNumber) }
    public init(_ number: Float) { self = .number(number as NSNumber) }
    public init(_ number: Double) { self = .number(number as NSNumber) }

    public init(_ number: NSNumber) {
        if type(of: number) == NSNumber.boolType {
            self.init(number.boolValue)
        } else {
            self = .number(number)
        }
    }

    public init(_ object: [String: JSON]) { self = .object(object) }
    public init(_ array: [JSON]) { self = .array(array) }
    public init(_ bool: Bool) { self = bool ? .true : . false }
    public init(_ null: NSNull) { self = .null }

    public init?(_ rawObject: [String: Any]) {
        var object: [String: JSON] = [:]
        for (key, value) in rawObject {
            guard let json = JSON(value) else {
                return nil
            }
            object[key] = json
        }
        self = .object(object)
    }

    public init?(_ rawArray: [Any]) {
        var array: [JSON] = []
        for element in rawArray {
            guard let json = JSON(element) else {
                return nil
            }
            array.append(json)
        }
        self = .array(array)
    }

    public init?(_ any: Any) {
        // FIXME: Should this initializer handle Data?
        switch any {
        case let string as String: self.init(string)
        case let number as NSNumber: self.init(number)
        case let object as [String: JSON]: self.init(object)
        case let rawObject as [String: Any]: self.init(rawObject)
        case let array as [JSON]: self.init(array)
        case let rawArray as [Any]: self.init(rawArray)
        case let null as NSNull: self.init(null)
        case _ as Optional<Any>: self = .null
        default: return nil
        }
    }
}

extension NSNumber {
    fileprivate static let boolType = type(of: NSNumber(value: true))
}

// MARK: - Literals

extension JSON: ExpressibleByStringLiteral {}
extension JSON: ExpressibleByIntegerLiteral {}
extension JSON: ExpressibleByFloatLiteral {}
extension JSON: ExpressibleByDictionaryLiteral {}
extension JSON: ExpressibleByArrayLiteral {}
extension JSON: ExpressibleByBooleanLiteral {}
extension JSON: ExpressibleByNilLiteral {}

extension JSON {
    public init(stringLiteral value: String) { self.init(value) }
    public init(integerLiteral value: Int) { self.init(value) }
    public init(floatLiteral value: Double) { self.init(value) }
    public init(dictionaryLiteral elements: (String, JSON)...) { self = .object(Dictionary(uniqueKeysWithValues: elements)) }
    public init(arrayLiteral elements: JSON...) { self = .array(elements) }
    public init(booleanLiteral value: Bool) { self = value ? .true : .false }
    public init(nilLiteral: ()) { self = .null }
}

// MARK: - Properties

extension JSON {
    public var string: String? {
        switch self {
        case .string(let string):
            return string
        default:
            return nil
        }
    }

    public var number: NSNumber? {
        switch self {
        case .number(let number):
            return number
        default:
            return nil
        }
    }

    public var object: [String: JSON]? {
        switch self {
        case .object(let object):
            return object
        default:
            return nil
        }
    }

    public var array: [JSON]? {
        switch self {
        case .array(let array):
            return array
        default:
            return nil
        }
    }

    public var bool: Bool? {
        switch self {
        case .true:
            return true
        case .false:
            return false
        default:
            return nil
        }
    }

    public var isNull: Bool {
        switch self {
        case .null:
            return true
        default:
            return false
        }
    }
}

// MARK: - CustomStringConvertible

extension JSON: CustomStringConvertible {
    public var description: String {
        switch self {
        case .string(let string):
            return "string(\"\(string)\")"
        case .number(let number):
            return "number(\(number))"
        case .object(let object):
            return "object(\(object)"
        case .array(let array):
            return "array(\(array)"
        case .true:
            return "true"
        case .false:
            return "false"
        case .null:
            return "null"
        }
    }
}
