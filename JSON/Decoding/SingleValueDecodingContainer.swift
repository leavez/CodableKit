//
//  SingleValueDecodingContainer.swift
//  JSON
//
//  Created by 李孛 on 2018/6/17.
//

extension JSON._Decoder: SingleValueDecodingContainer {
    func decodeNil() -> Bool { return topValue.isNull }
    func decode(_ type: Bool.Type) throws -> Bool { return try unbox(topValue, as: type) }
    func decode(_ type: Int.Type) throws -> Int { return try unbox(topValue, as: type) }
    func decode(_ type: Int8.Type) throws -> Int8 { return try unbox(topValue, as: type) }
    func decode(_ type: Int16.Type) throws -> Int16 { return try unbox(topValue, as: type) }
    func decode(_ type: Int32.Type) throws -> Int32 { return try unbox(topValue, as: type) }
    func decode(_ type: Int64.Type) throws -> Int64 { return try unbox(topValue, as: type) }
    func decode(_ type: UInt.Type) throws -> UInt { return try unbox(topValue, as: type) }
    func decode(_ type: UInt8.Type) throws -> UInt8 { return try unbox(topValue, as: type) }
    func decode(_ type: UInt16.Type) throws -> UInt16 { return try unbox(topValue, as: type) }
    func decode(_ type: UInt32.Type) throws -> UInt32 { return try unbox(topValue, as: type) }
    func decode(_ type: UInt64.Type) throws -> UInt64 { return try unbox(topValue, as: type) }
    func decode(_ type: Float.Type) throws -> Float { return try unbox(topValue, as: type) }
    func decode(_ type: Double.Type) throws -> Double { return try unbox(topValue, as: type) }
    func decode(_ type: String.Type) throws -> String { return try unbox(topValue, as: type) }
    func decode<T: Decodable>(_ type: T.Type) throws -> T { return try unbox(topValue, as: type) }
}
