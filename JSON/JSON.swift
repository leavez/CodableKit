//
//  JSON.swift
//  JSON
//
//  Created by 李孛 on 2018/6/13.
//

import Foundation

public typealias Number = NSNumber

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
    var number: Number? { get }
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

    public var number: Number? {
        return nil
    }
}
