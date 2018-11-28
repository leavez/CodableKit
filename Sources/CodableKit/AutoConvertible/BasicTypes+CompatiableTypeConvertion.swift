//
//  BasicType+CompatiableTypeConvertion.swift
//  CodableKit
//
//  Created by leave on 2018/11/28.
//

import Foundation

// MARK: - Integer

extension Int: CompatibleTypeConvertion {}
extension Int8: CompatibleTypeConvertion {}
extension Int16: CompatibleTypeConvertion {}
extension Int32: CompatibleTypeConvertion {}
extension Int64: CompatibleTypeConvertion {}
extension UInt: CompatibleTypeConvertion {}
extension UInt8: CompatibleTypeConvertion {}
extension UInt16: CompatibleTypeConvertion {}
extension UInt32: CompatibleTypeConvertion {}
extension UInt64: CompatibleTypeConvertion {}

extension CompatibleTypeConvertion where Self: FixedWidthInteger {
    
    static func convert(with decode: _DecodeMethod) -> Self? {
        if let s = try? decode.decode(String.self) {
            if let v = Self.init(s) {
                return v
            }
            if Double.init(s) != nil {
                // use convertion to double directly will lose precision, 
                // so we trim the content after "." manually
                if let index = s.index(of: ".") {
                    let sub = s[..<index]
                    return Self.init(sub)
                }
            }
        }
        return nil
    }
    
}


// MARK: - Float

extension Double: CompatibleTypeConvertion {
    
    static func convert(with decode: _DecodeMethod) -> Double? {
        if let s = try? decode.decode(String.self),
            let v = Double.init(s) {
            return v
        }
        return nil
    }
}

extension Float: CompatibleTypeConvertion {
    
    static func convert(with decode: _DecodeMethod) -> Float? {
        if let s = try? decode.decode(String.self),
            let v = Float.init(s) {
            return v
        }
        return nil
    }
}

#if canImport(CoreGraphics)
import CoreGraphics
extension CGFloat: CompatibleTypeConvertion {
    
    static func convert(with decode: _DecodeMethod) -> CGFloat? {
        if let s = try? decode.decode(String.self),
            let v = Double(s) {
            return CGFloat(v)
        }
        return nil
    }
}
#endif

// MARK: - Bool

extension Bool: CompatibleTypeConvertion {
    
    static func convert(with decode: _DecodeMethod) -> Bool? {
        
        if let v = try? decode.decode(Int.self) {
            return (v != 0)
        }
        if let s = try? decode.decode(String.self) {
            switch s {
            case "false", "False", "FALSE", "NO", "0":
                return false
            case "true", "True", "TRUE", "YES", "1":
                return true
            default:
                return nil
            }
        }
        return nil
    }
}


// MARK: - String

extension String: CompatibleTypeConvertion {
    
    static func convert(with decode: _DecodeMethod) -> String? {
        
        if let v = try? decode.decode(Int64.self) {
            return String(v)
        }
        if let v = try? decode.decode(Double.self) {
            return String(v)
        }
        if let v = try? decode.decode(Bool.self) {
            return String(v)
        }
        return nil
    }
}
