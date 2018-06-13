//
//  JSON.swift
//  JSON
//
//  Created by 李孛 on 2018/6/13.
//

import Foundation

public protocol JSON {
    typealias Object = [String: JSON]
    typealias Array = [JSON]
    typealias Number = NSNumber

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
