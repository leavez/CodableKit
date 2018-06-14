//
//  JSON.swift
//  JSON
//
//  Created by 李孛 on 2018/6/13.
//

import Foundation

/// A type represents JSON as native type.
///
/// [https://json.org](https://json.org)
public protocol JSON {
    typealias Object = [String: JSON]
    typealias Array = [JSON]
    typealias Number = NSNumber // FIXME: Use `NSNumber` for now, needs a better solution. Maybe `AnyNumeric`?

    var object: Object? { get }
    var array: Array? { get }
    var trueOrFalse: Bool? { get }
    var isNull: Bool { get }
    var string: String? { get }
    var number: Number? { get }
}

extension JSON {
    public var object: Object? {
        return nil
    }

    public var array: Array? {
        return nil
    }

    public var trueOrFalse: Bool? {
        return nil
    }

    public var isNull: Bool {
        return false
    }

    public var string: String? {
        return nil
    }

    public var number: Number? {
        return nil
    }
}

extension Dictionary: JSON where Key == String, Value: JSON {
    public var object: Object? {
        return self
    }
}

extension Array: JSON where Element: JSON {
    public var array: JSON.Array? {
        return self
    }
}

extension Bool: JSON {
    public var trueOrFalse: Bool? {
        return self
    }
}

extension NSNumber: JSON {
    public var trueOrFalse: Bool? {
        return self as? Bool
    }
}

extension Optional: JSON where Wrapped: JSON {
    public var object: Object? {
        return self?.object
    }

    public var array: JSON.Array? {
        return self?.array
    }

    public var trueOrFalse: Bool? {
        return self?.trueOrFalse
    }

    public var isNull: Bool {
        switch self {
        case nil:
            return true
        case let json?:
            return json.isNull
        }
    }

    public var string: String? {
        return self?.string
    }

    public var number: Number? {
        return self?.number
    }
}

extension NSNull: JSON {
    public var isNull: Bool {
        return true
    }
}

extension String: JSON {
    public var string: String? {
        return self
    }
}

extension Int: JSON {
    public var number: Number? {
        return self as NSNumber
    }
}

extension Int8: JSON {
    public var number: Number? {
        return self as NSNumber
    }
}

extension Int16: JSON {
    public var number: Number? {
        return self as NSNumber
    }
}

extension Int32: JSON {
    public var number: Number? {
        return self as NSNumber
    }
}

extension Int64: JSON {
    public var number: Number? {
        return self as NSNumber
    }
}

extension UInt: JSON {
    public var number: Number? {
        return self as NSNumber
    }
}

extension UInt8: JSON {
    public var number: Number? {
        return self as NSNumber
    }
}

extension UInt16: JSON {
    public var number: Number? {
        return self as NSNumber
    }
}

extension UInt32: JSON {
    public var number: Number? {
        return self as NSNumber
    }
}

extension UInt64: JSON {
    public var number: Number? {
        return self as NSNumber
    }
}

extension Float: JSON {
    public var number: Number? {
        return self as NSNumber
    }
}

extension Double: JSON {
    public var number: Number? {
        return self as NSNumber
    }
}

extension NSNumber {
    public var number: Number? {
        return self
    }
}
