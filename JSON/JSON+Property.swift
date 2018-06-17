//
//  JSON+Property.swift
//  JSON
//
//  Created by 李孛 on 2018/6/17.
//

import Foundation

extension JSON {
    public var string: String? {
        switch self {
        case .string(let string):
            return string
        default:
            return nil
        }
    }

    public var object: [String: JSON]? {
        switch self {
        case .object(let object):
            return object
        default:
            return nil
        }
    }

    public var array: [JSON]? {
        switch self {
        case .array(let array):
            return array
        default:
            return nil
        }
    }

    public var number: NSNumber? {
        switch self {
        case .number(let number):
            return number
        default:
            return nil
        }
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
        switch self {
        case .null:
            return true
        default:
            return false
        }
    }
}
