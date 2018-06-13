//
//  Object.swift
//  JSON
//
//  Created by 李孛 on 2018/6/14.
//

extension Dictionary: JSON where Key == String, Value: JSON {
    public var object: [String : JSON]? {
        return self
    }
}
