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
    
    static func convert(with decode: DecodingContainer) throws -> Self {
        if let s = try? decode.decode(String.self) {
            if let v = Self.init(s) {
                return v
            }
            if Double.init(s) != nil {
                // use convertion to double directly will lose precision,
                // so we trim the content after "." manually
                if let index = s.index(of: ".") {
                    let sub = s[..<index]
                    if let v = Self.init(sub) {
                        return v
                    }
                }
            }
        }
        throw CompatibleTypeConnotConvertionError()
    }
    
}


// MARK: - Float

extension Double: CompatibleTypeConvertion {
    
    static func convert(with decode: DecodingContainer) throws -> Double {
        if let s = try? decode.decode(String.self),
            let v = Double.init(s) {
            return v
        }
        throw CompatibleTypeConnotConvertionError()
    }
}

extension Float: CompatibleTypeConvertion {
    
    static func convert(with decode: DecodingContainer) throws -> Float {
        if let s = try? decode.decode(String.self),
            let v = Float.init(s) {
            return v
        }
        throw CompatibleTypeConnotConvertionError()
    }
}

#if canImport(CoreGraphics)
import CoreGraphics
extension CGFloat: CompatibleTypeConvertion {
    
    static func convert(with decode: DecodingContainer) throws -> CGFloat {
        if let s = try? decode.decode(String.self),
            let v = Double(s) {
            return CGFloat(v)
        }
        throw CompatibleTypeConnotConvertionError()
    }
}
#endif

// MARK: - Bool

extension Bool: CompatibleTypeConvertion {
    
    static func convert(with decode: DecodingContainer) throws -> Bool {
        
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
                throw CompatibleTypeConnotConvertionError()
            }
        }
        throw CompatibleTypeConnotConvertionError()
    }
}


// MARK: - String

extension String: CompatibleTypeConvertion {
    
    static func convert(with decode: DecodingContainer) throws -> String {
        
        if let v = try? decode.decode(Int64.self) {
            return String(v)
        }
        if let v = try? decode.decode(Double.self) {
            return String(v)
        }
        if let v = try? decode.decode(Bool.self) {
            return String(v)
        }
        throw CompatibleTypeConnotConvertionError()
    }
}



// MARK:- Date

extension Date: CompatibleTypeConvertion {
    
    static func convert(with decode: DecodingContainer) throws -> Date {
        // The data provided may not compatible with the dateStrategy in Decoder.
        // Then we try to use another 2 methods to decode the date, if we can save it.
        if let v = try? decode.decode(Double.self) {
            return Date(timeIntervalSince1970: v)
        }
        if let v = try? decode.decode(String.self),
            let date = RFC3339DateFormatter.date(from: v) {
            return date
        }
        throw CompatibleTypeConnotConvertionError()
    }
}

private let RFC3339DateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    return formatter
}()

