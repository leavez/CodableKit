//
//  JSONSerialization.swift
//  JSON
//
//  Created by 李孛 on 2018/6/18.
//

import Foundation

extension JSON {
    open class Serialization {
        open class func json(with data: Data) throws -> JSON {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            return JSON(jsonObject)!
        }
    }
}
