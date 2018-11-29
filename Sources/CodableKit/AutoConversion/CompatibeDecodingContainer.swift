//
//  MagicKeyedDecodingContainer.swift
//  CodableKit
//
//  Created by leave on 2018/11/28.
//

import Foundation


public struct CompatibleKeyedDecodingContainer<Key: CodingKey>:  KeyedDecodingContainerProtocol {
    
    public init(_ base: KeyedDecodingContainer<Key>) {
        self.wrapped = base
    }
    private let wrapped: KeyedDecodingContainer<Key>
    
    // -- implement `magic` for the decode method ---
    public func decode<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T  {
        // do some big things
        do {
            return try wrapped.decode(type, forKey: key)
        }
        catch DecodingError.typeMismatch(let targetType, let context) {
            
            if let transformableType = type as? CompatibleTypeConvertion.Type {
                do {
                    let v = try transformableType.convert(with: _KeyedDecodeMethod(wrapped, key:key))
                    return v as! T
                } catch {
                    // omit the error
                }
            }
            // rethrow if we cannot handle it
            throw DecodingError.typeMismatch(targetType, context)
        }
    }
}

public struct CompatibleUnkeyedDecodingContainer: UnkeyedDecodingContainer {
    
    public init(_ base: UnkeyedDecodingContainer) {
        self.wrapped = base
    }
    private var wrapped: UnkeyedDecodingContainer
    
    // -- implement `magic` for the decode method ---
    public mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        // do some big things
        do {
            return try wrapped.decode(type)
        }
        catch DecodingError.typeMismatch(let targetType, let context) {
            
            let _decode = _UnkeyedDecodeMethod(wrapped)
            if let transformableType = type as? CompatibleTypeConvertion.Type {
                do {
                    let v = try transformableType.convert(with: _decode)
                    // decode will change the inner value, so we should set it back
                    wrapped = _decode.inner
                    return v as! T
                } catch {
                    // omit the error
                }
            }
            // rethrow if we cannot handle it
            throw DecodingError.typeMismatch(targetType, context)
        }
    }
}


// --------------------------------------------------------------
//     forwording implementation
// --------------------------------------------------------------
extension CompatibleKeyedDecodingContainer {
    
    public var codingPath: [CodingKey] {
        return wrapped.codingPath
    }
    public var allKeys: [Key] {
        return wrapped.allKeys
    }
    public func contains(_ key: Key) -> Bool {
        return wrapped.contains(key)
    }
    public func superDecoder() throws -> Decoder {
        return try wrapped.superDecoder()
    }
    public func superDecoder(forKey key: Key) throws -> Decoder {
        return try wrapped.superDecoder(forKey: key)
    }
    public func nestedContainer<NestedKey: CodingKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> {
        return try wrapped.nestedContainer(keyedBy: type, forKey: key)
    }
    public func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        return try wrapped.nestedUnkeyedContainer(forKey: key)
    }
    public func decodeNil(forKey key: Key) throws -> Bool {
        return try wrapped.decodeNil(forKey: key)
    }
}

extension CompatibleUnkeyedDecodingContainer {
    
    public var codingPath: [CodingKey] {
        return wrapped.codingPath
    }
    public var count: Int? {
        return wrapped.count
    }
    public var isAtEnd: Bool {
        return wrapped.isAtEnd
    }
    public var currentIndex: Int {
        return wrapped.currentIndex
    }
    public mutating func nestedContainer<NestedKey: CodingKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> {
        return try wrapped.nestedContainer(keyedBy: type)
    }
    public mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        return try wrapped.nestedUnkeyedContainer()
    }
    public mutating func superDecoder() throws -> Decoder {
        return try wrapped.superDecoder()
    }
    public mutating func decodeNil() throws -> Bool {
        return try wrapped.decodeNil()
    }
}


// --------------------------------------------------------------
// Implement DecodingContainer for keyed/unkeyed/single container
// --------------------------------------------------------------
private struct _KeyedDecodeMethod<Key: CodingKey>: DecodingContainer {
    
    let inner: KeyedDecodingContainer<Key>
    let key: Key
    
    init(_ inner: KeyedDecodingContainer<Key>, key: Key) {
        self.inner = inner
        self.key = key
    }
    func decode<T: Decodable>(_ type: T.Type) throws -> T {
        return try inner.decode(type, forKey: key)
    }
    func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        return try inner.nestedUnkeyedContainer(forKey: key)
    }
    func nestedContainer<NestedKey: CodingKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> {
        return try inner.nestedContainer(keyedBy: type, forKey: key)
    }
}

private final class _UnkeyedDecodeMethod: DecodingContainer {
    var inner: UnkeyedDecodingContainer
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        return try inner.decode(type)
    }
    init(_ inner: UnkeyedDecodingContainer) {
        self.inner = inner
    }
    func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        return try inner.nestedUnkeyedContainer()
    }
    func nestedContainer<NestedKey: CodingKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> {
        return try inner.nestedContainer(keyedBy: type)
    }
}
