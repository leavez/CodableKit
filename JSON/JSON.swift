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
    public typealias String = Swift.String
    public typealias Number = NSNumber
    public typealias Object = [String: JSON]
    public typealias Array = [JSON]

    case string(String)
    case number(Number)
    case object(Object)
    case array(Array)
    case `true`
    case `false`
    case null
}

// MARK: - Literal

extension JSON: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(value)
    }
}

extension JSON: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = .number(value as Number)
    }
}

extension JSON: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = .number(value as Number)
    }
}

extension JSON: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, JSON)...) {
        self = .object(Object(uniqueKeysWithValues: elements))
    }
}

extension JSON: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: JSON...) {
        self = .array(elements)
    }
}

extension JSON: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        if value {
            self = .true
        } else {
            self = .false
        }
    }
}

extension JSON: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self = .null
    }
}

// MARK: - Convenience Property

extension JSON {
    public var string: String? {
        if case let .string(string) = self {
            return string
        }
        return nil
    }

    public var number: Number? {
        if case let .number(number) = self {
            return number
        }
        return nil
    }

    public var object: Object? {
        if case let .object(object) = self {
            return object
        }
        return nil
    }

    public var array: Array? {
        if case let .array(array) = self {
            return array
        }
        return nil
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
        if self == .null {
            return true
        }
        return false
    }
}
