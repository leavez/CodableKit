//
//  JSON+Initializer.swift
//  JSON
//
//  Created by 李孛 on 2018/6/18.
//

import Foundation

extension NSNumber {
    fileprivate static let boolType = type(of: NSNumber(value: true))
}

extension JSON {
    public init(_ string: String) { self = .string(string) }
    public init(_ number: Int) { self = .number(number as NSNumber) }
    public init(_ number: Int8) { self = .number(number as NSNumber) }
    public init(_ number: Int16) { self = .number(number as NSNumber) }
    public init(_ number: Int32) { self = .number(number as NSNumber) }
    public init(_ number: Int64) { self = .number(number as NSNumber) }
    public init(_ number: UInt) { self = .number(number as NSNumber) }
    public init(_ number: UInt8) { self = .number(number as NSNumber) }
    public init(_ number: UInt16) { self = .number(number as NSNumber) }
    public init(_ number: UInt32) { self = .number(number as NSNumber) }
    public init(_ number: UInt64) { self = .number(number as NSNumber) }
    public init(_ number: Float) { self = .number(number as NSNumber) }
    public init(_ number: Double) { self = .number(number as NSNumber) }

    public init(_ number: NSNumber) {
        if type(of: number) == NSNumber.boolType {
            self.init(number.boolValue)
        } else {
            self = .number(number)
        }
    }

    public init(_ object: [String: JSON]) { self = .object(object) }
    public init(_ array: [JSON]) { self = .array(array) }
    public init(_ bool: Bool) { self = bool ? .true : . false }
    public init(_ null: NSNull) { self = .null }

    public init?(_ rawObject: [String: Any]) {
        var object: [String: JSON] = [:]
        for (key, value) in rawObject {
            guard let json = JSON(value) else {
                return nil
            }
            object[key] = json
        }
        self = .object(object)
    }

    public init?(_ rawArray: [Any]) {
        var array: [JSON] = []
        for element in rawArray {
            guard let json = JSON(element) else {
                return nil
            }
            array.append(json)
        }
        self = .array(array)
    }

    public init?(_ any: Any) {
        switch any {
        case let string as String: self.init(string)
        case let number as NSNumber: self.init(number)
        case let object as [String: JSON]: self.init(object)
        case let rawObject as [String: Any]: self.init(rawObject)
        case let array as [JSON]: self.init(array)
        case let rawArray as [Any]: self.init(rawArray)
        case let null as NSNull: self.init(null)
        case _ as Optional<Any>: self = .null
        default: return nil
        }
    }
}
