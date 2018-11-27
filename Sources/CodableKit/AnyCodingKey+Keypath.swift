//
//  AnyCodingKey+Keypath.swift
//  CodableKit
//
//  Created by leave on 2018/11/27.
//

import Foundation

extension KeyedDecodingContainerProtocol where Key == AnyCodingKey {
    
    public func decode<T: Decodable>(_ key: Key, useKeyPath: Bool = true) throws -> T {
        let paths = key.keyPaths()
        if useKeyPath == false || paths.count <= 1 {
            return try self.decode(T.self, forKey: key)
        }

        let pathKeys = Array(paths[0..<paths.count-1])
        let nameKey = paths.last!
        let container = try self.nestedContainer(for: pathKeys)
        return try container.decode(T.self, forKey: nameKey)
    }
}

extension KeyedEncodingContainerProtocol where Key == AnyCodingKey {
    
    public mutating func encode<T: Encodable>(_ value: T, forKeyPath keyPath: Self.Key) throws {
    
        let paths = keyPath.keyPaths()
        if paths.count <= 1 {
            try self.encode(value, forKey: keyPath)
            return
        }
        
        let pathKeys = Array(paths[0..<paths.count-1])
        let nameKey = paths.last!
        var container = self.nestedContainer(for: pathKeys)
        try container.encode(value, forKey: nameKey)
    }
}


extension KeyedDecodingContainerProtocol where Key == AnyCodingKey {
    
    public func nestedContainer(forKey key: Key, useKeyPath: Bool = true) throws -> KeyedDecodingContainer<AnyCodingKey> {
        if !useKeyPath {
            return try self.nestedContainer(keyedBy: AnyCodingKey.self, forKey: key)
        }
        return try nestedContainer(for: key.keyPaths())
    }
    
    fileprivate func nestedContainer(for keyPaths:[Key]) throws -> KeyedDecodingContainer<AnyCodingKey> {
        assert(keyPaths.count > 0)
        var container = try self.nestedContainer(keyedBy: AnyCodingKey.self, forKey: keyPaths[0])
        for path in keyPaths[1..<keyPaths.count] {
            container = try container.nestedContainer(keyedBy: AnyCodingKey.self, forKey: path)
        }
        return container
    }
    
}

extension KeyedEncodingContainerProtocol where Key == AnyCodingKey {
    
    public mutating func nestedContainer(forKey key: Key, useKeyPath: Bool = true) -> KeyedEncodingContainer<AnyCodingKey> {
        if !useKeyPath {
            return nestedContainer(keyedBy: AnyCodingKey.self, forKey: key)
        }
        return nestedContainer(for: key.keyPaths())
    }
    
    fileprivate mutating func nestedContainer(for keyPaths: [Key]) -> KeyedEncodingContainer<AnyCodingKey> {
        assert(keyPaths.count > 0)
        var container = self.nestedContainer(keyedBy: AnyCodingKey.self, forKey: keyPaths[0])
        for path in keyPaths[1..<keyPaths.count] {
            container = container.nestedContainer(keyedBy: AnyCodingKey.self, forKey: path)
        }
        return container
    }
}


extension AnyCodingKey {

    /// Split the Key by "."
    fileprivate func keyPaths() -> [AnyCodingKey] {
        let keys = stringValue.components(separatedBy: ".").map( AnyCodingKey.init(stringValue:) )
        assert(keys.count > 0)
        return keys
    }
}
