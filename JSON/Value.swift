//
//  Value.swift
//  JSON
//
//  Created by 李孛 on 2018/6/14.
//

extension Bool: JSON {
    public var isTrue: Bool {
        return self == true
    }

    public var isFalse: Bool {
        return self == false
    }
}

extension Optional: JSON where Wrapped: JSON {
    public var isTrue: Bool {
        return self?.isTrue ?? false
    }

    public var isFalse: Bool {
        return self?.isFalse ?? false
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

    public var int: Int? {
        return self?.int
    }

    public var int8: Int8? {
        return self?.int8
    }

    public var int16: Int16? {
        return self?.int16
    }

    public var int32: Int32? {
        return self?.int32
    }

    public var int64: Int64? {
        return self?.int64
    }

    public var uInt: UInt? {
        return self?.uInt
    }

    public var uInt8: UInt8? {
        return self?.uInt8
    }

    public var uInt16: UInt16? {
        return self?.uInt16
    }

    public var uInt32: UInt32? {
        return self?.uInt32
    }

    public var uInt64: UInt64? {
        return self?.uInt64
    }

    public var float: Float? {
        return self?.float
    }

    public var double: Double? {
        return self?.double
    }
}
