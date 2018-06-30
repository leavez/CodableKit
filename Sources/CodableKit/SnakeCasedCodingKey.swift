//
//  SnakeCasedCodingKey.swift
//  CodableKit
//
//  Created by 李孛 on 2018/6/30.
//

public protocol SnakeCasedCodingKey: CodingKey {}

extension SnakeCasedCodingKey where Self: RawRepresentable, Self.RawValue == String {
    public var stringValue: String {
        return self.rawValue.snakeCased()
    }
}
