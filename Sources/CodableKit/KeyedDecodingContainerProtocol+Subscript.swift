//
//  KeyedDecodingContainerProtocol+Subscript.swift
//  CodableKit
//
//  Created by 李孛 on 2018/6/26.
//

extension KeyedDecodingContainerProtocol {
    public subscript<T: Decodable>(key: Key) -> T? {
        return try? decode(T.self, forKey: key)
    }
}
