//
//  AnyJSON.swift
//  JSON
//
//  Created by 李孛 on 2018/6/13.
//

public struct AnyJSON {
    public let base: Any

    public init(_ base: JSON) {
        self.base = base
    }
}

// MARK: - Literal

extension AnyJSON: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, JSON)...) {
        self.base = elements
    }
}

extension AnyJSON: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: JSON...) {
        base = elements
    }
}

extension AnyJSON: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        base = value
    }
}

extension AnyJSON: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        base = nilLiteral
    }
}

extension AnyJSON: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        base = value
    }
}

extension AnyJSON: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        base = value
    }
}

extension AnyJSON: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        base = value
    }
}
