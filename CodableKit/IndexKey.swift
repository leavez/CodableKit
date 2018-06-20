//
//  IndexKey.swift
//  JSON
//
//  Created by 李孛 on 2018/6/20.
//

public struct IndexKey: CodingKey {
    public let stringValue: String
    public let intValue: Int?

    public init?(stringValue: String) { return nil }
    public init?(intValue: Int) { return nil }

    public init(index: Int) {
        self.stringValue = "Index \(index)"
        self.intValue = index
    }
}
