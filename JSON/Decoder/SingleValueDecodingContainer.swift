//
//  SingleValueDecodingContainer.swift
//  JSON
//
//  Created by 李孛 on 2018/6/14.
//

struct _SingleValueDecodingContainer: SingleValueDecodingContainer {
    private let json: JSON
    private let decoder: _Decoder

    init(json: JSON, decoder: _Decoder, codingPath: [CodingKey]) {
        self.json = json
        self.decoder = decoder
        self.codingPath = codingPath
    }

    private func castNumberToType<T: Numeric>(_ type: T.Type) throws -> T {
        guard let number = json.number else {
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: json)
        }
        guard let value = number as? T else {
            let description = "Parsed JSON number <\(number)> does not fit in \(type)."
            throw DecodingError.dataCorruptedError(in: self, debugDescription: description)
        }
        return value
    }

    // MARK: - SingleValueDecodingContainer

    let codingPath: [CodingKey]

    func decodeNil() -> Bool {
        return json.isNull
    }

    func decode(_ type: Bool.Type) throws -> Bool {
        guard let value = json.bool else {
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: json)
        }
        return value
    }

    func decode(_ type: Int.Type) throws -> Int {
        return try castNumberToType(type)
    }

    func decode(_ type: Int8.Type) throws -> Int8 {
        return try castNumberToType(type)
    }

    func decode(_ type: Int16.Type) throws -> Int16 {
        return try castNumberToType(type)
    }

    func decode(_ type: Int32.Type) throws -> Int32 {
        return try castNumberToType(type)
    }

    func decode(_ type: Int64.Type) throws -> Int64 {
        return try castNumberToType(type)
    }

    func decode(_ type: UInt.Type) throws -> UInt {
        return try castNumberToType(type)
    }

    func decode(_ type: UInt8.Type) throws -> UInt8 {
        return try castNumberToType(type)
    }

    func decode(_ type: UInt16.Type) throws -> UInt16 {
        return try castNumberToType(type)
    }

    func decode(_ type: UInt32.Type) throws -> UInt32 {
        return try castNumberToType(type)
    }

    func decode(_ type: UInt64.Type) throws -> UInt64 {
        return try castNumberToType(type)
    }

    func decode(_ type: Float.Type) throws -> Float {
        return try castNumberToType(type)
    }

    func decode(_ type: Double.Type) throws -> Double {
        return try castNumberToType(type)
    }

    func decode(_ type: String.Type) throws -> String {
        guard let value = json.string else {
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: json)
        }
        return value
    }

    func decode<T: Decodable>(_ type: T.Type) throws -> T {
        decoder.stroage.append(json)
        defer {
            decoder.stroage.removeLast()
        }
        return try T.init(from: decoder)
    }
}
