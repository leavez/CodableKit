//
//  JSON+Literal.swift
//  JSON
//
//  Created by 李孛 on 2018/6/15.
//

import Foundation

extension JSON {
    public init(stringLiteral value: String) { self = .string(value) }
    public init(integerLiteral value: Int) { self = .number(NSNumber(value: value)) }
    public init(floatLiteral value: Double) { self = .number(NSNumber(value: value)) }
    public init(dictionaryLiteral elements: (String, JSON)...) { self = .object(Dictionary(uniqueKeysWithValues: elements)) }
    public init(arrayLiteral elements: JSON...) { self = .array(elements) }
    public init(booleanLiteral value: Bool) { self = value ? .true : .false }
    public init(nilLiteral: ()) { self = .null }
}

extension JSON: ExpressibleByStringLiteral {}
extension JSON: ExpressibleByIntegerLiteral {}
extension JSON: ExpressibleByFloatLiteral {}
extension JSON: ExpressibleByDictionaryLiteral {}
extension JSON: ExpressibleByArrayLiteral {}
extension JSON: ExpressibleByBooleanLiteral {}
extension JSON: ExpressibleByNilLiteral {}
