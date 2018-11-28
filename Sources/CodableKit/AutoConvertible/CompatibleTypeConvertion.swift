//
//  MagicTransformable.swift
//  CodableKit
//
//  Created by leave on 2018/11/28.
//

import Foundation

internal protocol CompatibleTypeConvertion {
    static func convert(with decode: _DecodeMethod) -> Self?
}

internal protocol _DecodeMethod {
    func decode<T: Decodable>(_ type: T.Type) throws -> T
}




extension Int: CompatibleTypeConvertion {
    internal static func convert(with decode: _DecodeMethod) -> Int? {
        if let s = try? decode.decode(String.self), let v = Int(s) {
            return v
        }
        return nil
    }
}
