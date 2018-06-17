//
//  Decoder+Unboxing.swift
//  JSON
//
//  Created by 李孛 on 2018/6/17.
//

extension JSON._Decoder {
    private func expectNonNull<T>(_ value: JSON, for type: T.Type) throws {
        guard !value.isNull else {
            let description = "Expected \(type) but found null value instead."
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
            throw DecodingError.valueNotFound(type, context)
        }
    }

    private func unbox<T: Numeric>(_ value: JSON, asNumberFitIn type: T.Type) throws -> T {
        try expectNonNull(value, for: type)
        guard let number = value.number else {
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: value)
        }
        guard let result = number as? T else {
            let description = "Parsed JSON number <\(number)> does not fit in \(type)."
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
            throw DecodingError.dataCorrupted(context)
        }
        return result
    }
}

extension JSON._Decoder {
    func unbox(_ value: JSON, as type: Bool.Type) throws -> Bool {
        try expectNonNull(value, for: type)
        guard let result = value.bool else {
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: value)
        }
        return result
    }

    func unbox(_ value: JSON, as type: Int.Type) throws -> Int { return try unbox(value, asNumberFitIn: type) }
    func unbox(_ value: JSON, as type: Int8.Type) throws -> Int8 { return try unbox(value, asNumberFitIn: type) }
    func unbox(_ value: JSON, as type: Int16.Type) throws -> Int16 { return try unbox(value, asNumberFitIn: type) }
    func unbox(_ value: JSON, as type: Int32.Type) throws -> Int32 { return try unbox(value, asNumberFitIn: type) }
    func unbox(_ value: JSON, as type: Int64.Type) throws -> Int64 { return try unbox(value, asNumberFitIn: type) }
    func unbox(_ value: JSON, as type: UInt.Type) throws -> UInt { return try unbox(value, asNumberFitIn: type) }
    func unbox(_ value: JSON, as type: UInt8.Type) throws -> UInt8 { return try unbox(value, asNumberFitIn: type) }
    func unbox(_ value: JSON, as type: UInt16.Type) throws -> UInt16 { return try unbox(value, asNumberFitIn: type) }
    func unbox(_ value: JSON, as type: UInt32.Type) throws -> UInt32 { return try unbox(value, asNumberFitIn: type) }
    func unbox(_ value: JSON, as type: UInt64.Type) throws -> UInt64 { return try unbox(value, asNumberFitIn: type) }
    func unbox(_ value: JSON, as type: Float.Type) throws -> Float { return try unbox(value, asNumberFitIn: type) }
    func unbox(_ value: JSON, as type: Double.Type) throws -> Double { return try unbox(value, asNumberFitIn: type) }

    func unbox(_ value: JSON, as type: String.Type) throws -> String {
        try expectNonNull(value, for: type)
        guard let result = value.string else {
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: value)
        }
        return result
    }

    func unbox<T: Decodable>(_ value: JSON, as type: T.Type) throws -> T {
        try expectNonNull(value, for: type)
        stroage.append(value)
        defer { stroage.removeLast() }
        return try T(from: self)
    }
}
