//
//  KeyedDecodingContainerProtocol.swift
//  CodableKit
//
//  Created by 李孛 on 2018/6/26.
//

extension KeyedDecodingContainerProtocol {
    public func decode<T: Decodable>(_ key: Key) throws -> T {
        return try decode(T.self, forKey: key)
    }

    public func decodeIfPresent<T: Decodable>(_ key: Key) throws -> T? {
        return try decodeIfPresent(T.self, forKey: key)
    }

    public subscript<T: Decodable>(key: Key) -> T? {
        return try? decode(T.self, forKey: key)
    }
}
