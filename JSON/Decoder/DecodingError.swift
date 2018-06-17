//
//  DecodingError.swift
//  JSON
//
//  Created by 李孛 on 2018/6/16.
//

import Foundation

extension DecodingError {
    static func _typeMismatch(at path: [CodingKey], expectation: Any.Type, reality: Any) -> DecodingError {
        let description = "Expected to decode \(expectation) but found \(reality) instead."
        return .typeMismatch(expectation, Context(codingPath: path, debugDescription: description))
    }

    static func _dataCorrupted(
        at path: [CodingKey],
        parsedNumber number: NSNumber,
        notFitIn type: Any.Type
    ) -> DecodingError {
        let description = "Parsed JSON number <\(number)> does not fit in \(type)."
        return .dataCorrupted(DecodingError.Context(codingPath: path, debugDescription: description))
    }
}
