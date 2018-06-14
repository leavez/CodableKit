//
//  JSON.swift
//  JSON
//
//  Created by 李孛 on 2018/6/13.
//

import Foundation

/// JSON value.
///
/// [https://json.org](https://json.org)
public protocol JSON {
    var string: String? { get }
    var number: Number? { get }
    var object: Object? { get }
    var array : Array?  { get }
    var bool  : Bool?   { get }
    var isNull: Bool    { get }
}

extension JSON {
    public var string: String? { return nil }
    public var number: Number? { return nil }
    public var object: Object? { return nil }
    public var array : Array?  { return nil }
    public var bool  : Bool?   { return nil }
    public var isNull: Bool    { return false }
}

// MARK: - String

/// JSON string.
///
/// [https://json.org](https://json.org)
public typealias String = Swift.String
extension String: JSON { public var string: String? { return self } }

// MARK: - Number

/// JSON number.
///
/// [https://json.org](https://json.org)
public typealias Number = NSNumber // FIXME: Use NSNumber for now, needs a better solution. Maybe AnyNumeric?
extension Int     : JSON { public var number: Number? { return self as NSNumber } }
extension Int8    : JSON { public var number: Number? { return self as NSNumber } }
extension Int16   : JSON { public var number: Number? { return self as NSNumber } }
extension Int32   : JSON { public var number: Number? { return self as NSNumber } }
extension Int64   : JSON { public var number: Number? { return self as NSNumber } }
extension UInt    : JSON { public var number: Number? { return self as NSNumber } }
extension UInt8   : JSON { public var number: Number? { return self as NSNumber } }
extension UInt16  : JSON { public var number: Number? { return self as NSNumber } }
extension UInt32  : JSON { public var number: Number? { return self as NSNumber } }
extension UInt64  : JSON { public var number: Number? { return self as NSNumber } }
extension Float   : JSON { public var number: Number? { return self as NSNumber } }
extension Double  : JSON { public var number: Number? { return self as NSNumber } }
extension NSNumber: JSON { public var number: Number? { return self } }

// MARK: - Object

/// JSON object.
///
/// [https://json.org](https://json.org)
public typealias Object = [String: JSON]
extension Dictionary: JSON where Key == String, Value: JSON { public var object: Object? { return self } }

// MARK: - Array

/// JSON array.
///
/// [https://json.org](https://json.org)
public typealias Array = [JSON]
extension Swift.Array: JSON where Element: JSON { public var array: Array? { return self } }

// MARK: - Bool

extension Bool: JSON { public var bool: Bool? { return self } }
extension NSNumber   { public var bool: Bool? { return self as? Bool } }

// MARK: - Null

extension Optional: JSON where Wrapped: JSON {
    public var string: String? { return self?.string }
    public var number: Number? { return self?.number }
    public var object: Object? { return self?.object }
    public var array: Array? { return self?.array }
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

extension NSNull: JSON { public var isNull: Bool { return true } }
