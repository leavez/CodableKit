//
//  Array.swift
//  JSON
//
//  Created by 李孛 on 2018/6/14.
//

extension Array: JSON where Element: JSON {
    public var array: [JSON]? {
        return self
    }
}
