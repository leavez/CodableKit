//
//  Container+Magical.swift
//  CodableKit
//
//  Created by leave on 2018/11/28.
//

import Foundation


/// It make the container to be able to convert from campatible types automatically when using
/// `decode(:)` method, if target type of data is not the same with we specified. e.g. :
///
///   ```
///   // JSON: {"a": "123"}
///   Model{ let a: Int
///        init(from decoder:Decoder) throws {
///            let container = decoder.container(keyedBy:CodingKey.self).compatible()
///            a = try container.decode(.a) // it will auto transform "123"(string) to 123(int)
///        }
///   }```
///
extension KeyedDecodingContainer {
    public func compatible() -> CompatibleKeyedDecodingContainer<Key> {
        return CompatibleKeyedDecodingContainer(self)
    }
}
extension UnkeyedDecodingContainer {
    public func compatible() -> CompatibleUnkeyedDecodingContainer {
        return CompatibleUnkeyedDecodingContainer(self)
    }
}
extension SingleValueDecodingContainer {
    public func compatible() -> CompatibleSingleValueDecodingContainer {
        return CompatibleSingleValueDecodingContainer(self)
    }
}
