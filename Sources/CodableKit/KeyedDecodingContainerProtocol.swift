//
//  KeyedDecodingContainerProtocol.swift
//  CodableKit
//
//  Created by 李孛 on 2018/6/26.
//

extension KeyedDecodingContainerProtocol {
    /// Decodes a value for the given key.
    ///
    /// - Parameter key: The key that the decoded value is associated with.
    /// - Returns: A value of the requested type, if present for the given key and convertible to the requested type.
    public func decode<T: Decodable>(_ key: Key) throws -> T {
        return try decode(T.self, forKey: key)
    }

    /// Decodes a value for the given key, if present.
    ///
    /// - Parameter key: The key that the decoded value is associated with.
    /// - Returns: A decoded value of the requested type, or `nil` if the `Decoder` does not have an entry associated
    ///   with the given key, or if the value is a null value.
    public func decodeIfPresent<T: Decodable>(_ key: Key) throws -> T? {
        return try decodeIfPresent(T.self, forKey: key)
    }

    public subscript<T: Decodable>(key: Key) -> T? {
        return try? decode(T.self, forKey: key)
    }
}
