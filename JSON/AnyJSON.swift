//
//  AnyJSON.swift
//  JSON
//
//  Created by 李孛 on 2018/6/14.
//

import Foundation

/// A type-erased JSON value.
public struct AnyJSON {

    /// The value wrapped by this instance.
    ///
    /// The value can be:
    ///
    /// - `JSON`
    /// - `[String: AnyJSON]`
    /// - `[AnyJSON]`
    /// - `NSDictionary`
    /// - `NSArray`
    public let base: Any

    public init(_ json: JSON) {
        base = json
    }

    public init?(_ data: Data) {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data) else {
            return nil
        }
        base = jsonObject
    }

    public init?(_ base: Any) {
        guard JSONSerialization.isValidJSONObject(base) else {
            return nil
        }
        self.base = base
    }

    private init(jsonObject: Any) {
        assert(JSONSerialization.isValidJSONObject(jsonObject))
        base = jsonObject
    }

    private var json: JSON? {
        return base as? JSON
    }
}

extension AnyJSON: JSON {
    public var object: Object? {
        switch base {
        case let json as JSON:
            return json.object
        case let object as [String: AnyJSON]:
            return object
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
        case let anyJSON as [AnyJSON]:
            return anyJSON
        case let jsonObject as [Any]:
            return jsonObject.map(AnyJSON.init(jsonObject:))
        default:
            return nil
        }
    }

    public var trueOrFalse: Bool? {
        return json?.trueOrFalse
    }

    public var isNull: Bool {
        return json?.isNull ?? false
    }

    public var string: String? {
        return json?.string
    }

    public var number: Number? {
        return json?.number
    }
}

extension AnyJSON: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, AnyJSON)...) {
        base = Dictionary(uniqueKeysWithValues: elements)
    }
}

extension AnyJSON: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: AnyJSON...) {
        base = elements
    }
}

extension AnyJSON: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self.init(value)
    }
}

extension AnyJSON: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self.init(NSNull())
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
