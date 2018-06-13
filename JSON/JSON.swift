//
//  JSON.swift
//  JSON
//
//  Created by 李孛 on 2018/6/13.
//

/// https://json.org
public protocol JSON {
    // object
    var object: [String: JSON]? { get }
    // array
    var array: [JSON]? { get }
    // value
    var isTrue: Bool { get }
    var isFalse: Bool { get }
    var isNull: Bool { get }
    // string
    var string: String? { get }
    // number
    var int: Int? { get }
    var int8: Int8? { get }
    var int16: Int16? { get }
    var int32: Int32? { get }
    var int64: Int64? { get }
    var uInt: UInt? { get }
    var uInt8: UInt8? { get }
    var uInt16: UInt16? { get }
    var uInt32: UInt32? { get }
    var uInt64: UInt64? { get }
    var float: Float? { get }
    var double: Double? { get }
}

extension JSON {
    public var object: [String: JSON]? {
        return nil
    }

    public var array: [JSON]? {
        return nil
    }

    public var isTrue: Bool {
        return false
    }

    public var isFalse: Bool {
        return false
    }

    public var isNull: Bool {
        return false
    }

    public var string: String? {
        return nil
    }

    public var int: Int? {
        return nil
    }

    public var int8: Int8? {
        return nil
    }

    public var int16: Int16? {
        return nil
    }

    public var int32: Int32? {
        return nil
    }

    public var int64: Int64? {
        return nil
    }

    public var uInt: UInt? {
        return nil
    }

    public var uInt8: UInt8? {
        return nil
    }

    public var uInt16: UInt16? {
        return nil
    }

    public var uInt32: UInt32? {
        return nil
    }

    public var uInt64: UInt64? {
        return nil
    }

    public var float: Float? {
        return nil
    }

    public var double: Double? {
        return nil
    }
}
