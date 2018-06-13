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
}
