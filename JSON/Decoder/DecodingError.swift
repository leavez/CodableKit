//
//  DecodingError.swift
//  JSON
//
//  Created by 李孛 on 2018/6/16.
//

extension DecodingError {
    static func _typeMismatch(at path: [CodingKey], expectation: Any.Type, reality: Any) -> DecodingError {
        let description = "Expected to decode \(expectation) but found \(reality) instead."
        return .typeMismatch(expectation, Context(codingPath: path, debugDescription: description))
    }
}
