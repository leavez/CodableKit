//
//  AnyJSON.swift
//  JSON
//
//  Created by 李孛 on 2018/6/14.
//

import Foundation

public struct AnyJSON {
    public let base: Any

    init?(_ base: Any) {
        guard base is JSON || JSONSerialization.isValidJSONObject(base) else {
            return nil
        }
        self.base = base
    }
}

extension AnyJSON: JSON {
    private var json: JSON {
        return base as! JSON
    }

    public var object: Object? {
        return nil
    }

    public var array: JSON.Array? {
        return base as? JSON.Array
    }

    public var trueOrFalse: Bool? {
        return json.trueOrFalse
    }

    public var isNull: Bool {
        return json.isNull
    }

    public var string: String? {
        return json.string
    }

    public var number: Number? {
        return json.number
    }
}
