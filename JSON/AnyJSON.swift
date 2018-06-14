//
//  AnyJSON.swift
//  JSON
//
//  Created by 李孛 on 2018/6/14.
//

import Foundation

public struct AnyJSON {
    public let base: Any

    public init(_ base: JSON) {
        self.base = base
    }

    public init?(_ base: Data) {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: base) else {
            return nil
        }
        self.base = jsonObject
    }

    public init?(_ base: Any) {
        guard JSONSerialization.isValidJSONObject(base) else {
            return nil
        }
        self.base = base
    }

    private init(jsonObject: Any) {
        self.base = jsonObject
    }
}

extension AnyJSON: JSON {
    public var object: Object? {
        switch base {
        case let json as JSON:
            return json.object
        case let jsonObject as [String: Any]:
            return jsonObject.mapValues(AnyJSON.init(jsonObject:))
        default:
            return nil
        }
    }

    public var array: JSON.Array? {
        switch base {
        case let json as JSON:
            return json.array
        case let jsonObject as [Any]:
            return jsonObject.map(AnyJSON.init(jsonObject:))
        default:
            return nil
        }
    }

    public var trueOrFalse: Bool? {
        return (base as? JSON)?.trueOrFalse
    }

    public var isNull: Bool {
        return (base as? JSON)?.isNull ?? false
    }

    public var string: String? {
        return (base as? JSON)?.string
    }

    public var number: Number? {
        return (base as? JSON)?.number
    }
}

extension AnyJSON: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, AnyJSON)...) {
        self.base = Dictionary(uniqueKeysWithValues: elements)
    }
}

extension AnyJSON: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: AnyJSON...) {
        self.base = elements
    }
}

extension AnyJSON: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self.init(value)
    }
}

extension AnyJSON: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self.base = NSNull()
    }
}

extension AnyJSON: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension AnyJSON: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self.init(value)
    }
}

extension AnyJSON: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self.init(value)
    }
}
