//
//  Serialization.swift
//  JSON
//
//  Created by 李孛 on 2018/6/18.
//

import Foundation

extension JSON {
    public typealias Serialization = JSONSerialization
}

extension JSONSerialization {
    open class func json(with data: Data) throws -> JSON {
        let jsonObject = try self.jsonObject(with: data)
        return JSON(jsonObject)!
    }
}
