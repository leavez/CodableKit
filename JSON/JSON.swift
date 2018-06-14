//
//  JSON.swift
//  JSON
//
//  Created by 李孛 on 2018/6/13.
//

import Foundation

/// A type represents JSON value as native type.
///
/// [https://json.org](https://json.org)
public protocol JSON {
    typealias Number = NSNumber // FIXME: Use `NSNumber` for now, needs a better solution. Maybe `AnyNumeric`?
    typealias Object = [String: JSON]
    typealias Array = [JSON]

    var string: String? { get }
    var number: Number? { get }
    var object: Object? { get }
    var array: Array? { get }
    var bool: Bool? { get }

    var isNull: Bool { get }
}

// MARK: - Default

extension JSON {
    public var string: String? { return nil }
    public var number: Number? { return nil }
    public var object: Object? { return nil }
    public var array: Array? { return nil }
    public var bool: Bool? { return nil }
    public var isNull: Bool { return false }
}

// MARK: - String

extension String: JSON {
    public var string: String? { return self }
}

// MARK: - Number

extension Int: JSON {
    public var number: Number? { return self as NSNumber }
}

extension Int8: JSON {
    public var number: Number? { return self as NSNumber }
}

extension Int16: JSON {
    public var number: Number? { return self as NSNumber }
}

extension Int32: JSON {
    public var number: Number? { return self as NSNumber }
}

extension Int64: JSON {
    public var number: Number? { return self as NSNumber }
}

extension UInt: JSON {
    public var number: Number? { return self as NSNumber }
}

extension UInt8: JSON {
    public var number: Number? { return self as NSNumber }
}

extension UInt16: JSON {
    public var number: Number? { return self as NSNumber }
}

extension UInt32: JSON {
    public var number: Number? { return self as NSNumber }
}

extension UInt64: JSON {
    public var number: Number? { return self as NSNumber }
}

extension Float: JSON {
    public var number: Number? { return self as NSNumber }
}

extension Double: JSON {
    public var number: Number? { return self as NSNumber }
}

extension NSNumber: JSON {
    public var number: Number? { return self }
}

// MARK: - Object

extension Dictionary: JSON where Key == String, Value: JSON {
    public var object: Object? { return self }
}

// MARK: - Array

extension Array: JSON where Element: JSON {
    public var array: JSON.Array? { return self }
}

// MARK: - Bool

extension Bool: JSON {
    public var bool: Bool? { return self }
}

extension NSNumber {
    public var bool: Bool? { return self as? Bool }
}

// MARK: - Null

extension Optional: JSON where Wrapped: JSON {
    public var string: String? { return self?.string }
    public var number: Number? { return self?.number }
    public var object: Object? { return self?.object }
    public var array: JSON.Array? { return self?.array }
    public var bool: Bool? { return self?.bool }

    public var isNull: Bool {
        switch self {
        case nil:
            return true
        case let json?:
            return json.isNull
        }
    }
}

extension NSNull: JSON {
    public var isNull: Bool { return true }
}
