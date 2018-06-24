//
//  AnyCodingKey.swift
//  JSON
//
//  Created by 李孛 on 2018/6/20.
//

struct AnyCodingKey: CodingKey {
    static let `super` = AnyCodingKey(stringValue: "super")!

    let stringValue: String
    let intValue: Int?

    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }

    init?(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }

    public init(index: Int) {
        self.stringValue = "Index \(index)"
        self.intValue = index
    }
}
