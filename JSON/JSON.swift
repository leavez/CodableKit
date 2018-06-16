//
//  JSON.swift
//  JSON
//
//  Created by 李孛 on 2018/6/15.
//

import Foundation

/// JSON value.
///
/// [https://json.org](https://json.org)
public enum JSON {
    case string(String)
    case number(NSNumber)
    case object([String: JSON])
    case array([JSON])
    case `true`
    case `false`
    case null
}

private let booleanType = type(of: NSNumber(value: true))

extension JSON {
    public init?(_ any: Any) {
        switch any {
        case let string as String:
            self = .string(string)
        case let number as NSNumber:
            if type(of: number) == booleanType {
                if number.boolValue {
                    self = .true
                } else {
                    self = .false
                }
            } else {
                self = .number(number)
            }
        case let _object as [String: Any]:
            var object: [String: JSON] = [:]
            for (key, value) in _object {
                guard let json = JSON(value) else {
                    return nil
                }
                object[key] = json
            }
            self = .object(object)
        case let _array as [Any]:
            var array: [JSON] = []
            for element in _array {
                guard let json = JSON(element) else {
                    return nil
                }
                array.append(json)
            }
            self = .array(array)
        case _ as NSNull:
            self = .null
        default:
            return nil
        }
    }
}

extension JSON {
    public var isNull: Bool {
        switch self {
        case .null:
            return true
        default:
            return false
        }
    }
}
