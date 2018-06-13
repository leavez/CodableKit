//
//  Number.swift
//  JSON
//
//  Created by 李孛 on 2018/6/14.
//

extension JSON.Number: JSON {
    public var number: Number? {
        return self
    }
}

extension Int: JSON {
    public var number: Number? {
        return self as Number
    }
}

extension Int8: JSON {
    public var number: Number? {
        return self as Number
    }
}

extension Int16: JSON {
    public var number: Number? {
        return self as Number
    }
}

extension Int32: JSON {
    public var number: Number? {
        return self as Number
    }
}

extension Int64: JSON {
    public var number: Number? {
        return self as Number
    }
}

extension UInt: JSON {
    public var number: Number? {
        return self as Number
    }
}

extension UInt8: JSON {
    public var number: Number? {
        return self as Number
    }
}

extension UInt16: JSON {
    public var number: Number? {
        return self as Number
    }
}

extension UInt32: JSON {
    public var number: Number? {
        return self as Number
    }
}

extension UInt64: JSON {
    public var number: Number? {
        return self as Number
    }
}

extension Float: JSON {
    public var number: Number? {
        return self as Number
    }
}

extension Double: JSON {
    public var number: Number? {
        return self as Number
    }
}
