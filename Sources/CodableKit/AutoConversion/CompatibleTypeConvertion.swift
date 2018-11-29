//
//  MagicTransformable.swift
//  CodableKit
//
//  Created by leave on 2018/11/28.
//

import Foundation

internal protocol CompatibleTypeConvertion {
    static func convert(with decode: DecodingContainer) throws -> Self
}

internal protocol DecodingContainer {
    func decode<T: Decodable>(_ type: T.Type) throws -> T
    func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer
    func nestedContainer<NestedKey: CodingKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey>
}

internal struct CompatibleTypeConnotConvertionError: Error {}
