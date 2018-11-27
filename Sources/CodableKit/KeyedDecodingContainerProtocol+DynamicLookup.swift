//
//  KeyedDecodingContainerProtocol+DynamicLookup.swift
//  CodableKit
//
//  Created by leave on 2018/11/27.
//

import Foundation


/// With the help of @dynamicMemberLookup, API could be simplified:
///
///     // old
///     time = try container.decode("time")
///     // new
///     time = try container.time()
///
@dynamicMemberLookup public protocol DynmaicLookupKeyedDecoding {}

extension KeyedDecodingContainer: DynmaicLookupKeyedDecoding {}

extension DynmaicLookupKeyedDecoding where Self == KeyedDecodingContainer<AnyCodingKey> {
    
    public subscript<T: Decodable>(dynamicMember member: String) -> () throws -> T {
        return { try self.decode(AnyCodingKey(stringValue: member)) }
    }
}

