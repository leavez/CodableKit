//
//  CompatiableTypeConvertion+Optional.swift
//  CodableKit
//
//  Created by leave on 2018/11/29.
//

import Foundation

// MARK:- Array

extension Array: CompatibleTypeConvertion where Element: CompatibleTypeConvertion, Element: Decodable {
    
    static func convert(with decode: DecodingContainer) throws -> Array<Element> {
        do {
            var unkeyedContainer = try decode.nestedUnkeyedContainer().compatible()
            var result = [Element]()
            while !unkeyedContainer.isAtEnd {
                result.append(try unkeyedContainer.decode(Element.self))
            }
            return result
        }
        catch {
            throw CompatibleTypeConnotConvertionError()
        }
    }
}

extension Set: CompatibleTypeConvertion where Element: CompatibleTypeConvertion, Element: Decodable {
    static func convert(with decode: DecodingContainer) throws -> Set<Element> {
        do {
            var unkeyedContainer = try decode.nestedUnkeyedContainer().compatible()
            var result = Set<Element>()
            while !unkeyedContainer.isAtEnd {
                result.insert(try unkeyedContainer.decode(Element.self))
            }
            return result
        }
        catch {
            throw CompatibleTypeConnotConvertionError()
        }
    }
}




// MARK:- Dictionary

/// Only string key is supported here
extension Dictionary: CompatibleTypeConvertion where Key == String, Value: CompatibleTypeConvertion, Value: Decodable {
    
    static func convert(with decode: DecodingContainer) throws -> Dictionary<Key, Value> {
        do {
            // Here depends on AnyCodingKey
            let keyedContainer = try decode.nestedContainer(keyedBy: AnyCodingKey.self).compatible()
            var result = [String:Value]()
            for key in keyedContainer.allKeys {
                let v = try keyedContainer.decode(Value.self, forKey: key)
                result[key.stringValue] = v
            }
            return result
        }
        catch {
            throw CompatibleTypeConnotConvertionError()
        }
    }
}



// MARK:- Optional


extension Optional: CompatibleTypeConvertion {
    
    static func convert(with decode: DecodingContainer) throws -> Optional<Wrapped> {
        if let T = Wrapped.self as? Decodable.Type, Wrapped.self is CompatibleTypeConvertion.Type {
            if let v = try? T.decodeSelf(decode) as? Wrapped {
                return v
            }
        }
        // Optional don't throw error by defalut.
        return nil
    }
}

extension Decodable {
    // only a small tricks to call decode method with type-safe
    fileprivate static func decodeSelf(_ de: DecodingContainer) throws -> Self {
        return try de.decode(Self.self)
    }
}

