//
//  SingleValueDecodingContainer.swift
//  JSON
//
//  Created by 李孛 on 2018/6/13.
//

struct _SingleValueDecodingContainer: SingleValueDecodingContainer {
    let json: JSON
    let decoder: _JSONDecoder

    init(json: JSON, decoder: _JSONDecoder, codingPath: [CodingKey]) {
        self.json = json
        self.decoder = decoder
        self.codingPath = codingPath
    }

    let codingPath: [CodingKey]

    func decodeNil() -> Bool {
        return json.isNull
    }

    func decode(_ type: Bool.Type) throws -> Bool {
        if json.isTrue {
            return true
        }
        if json.isFalse {
            return false
        }
        // FIXME: Add debugDescription.
        throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
    }

    func decode(_ type: Int.Type) throws -> Int {
        guard let int = json.int else {
            // FIXME: Add debugDescription.
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        return int
    }

    func decode(_ type: Int8.Type) throws -> Int8 {
        guard let int8 = json.int8 else {
            // FIXME: Add debugDescription.
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        return int8
    }

    func decode(_ type: Int16.Type) throws -> Int16 {
        guard let int16 = json.int16 else {
            // FIXME: Add debugDescription.
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        return int16
    }

    func decode(_ type: Int32.Type) throws -> Int32 {
        guard let int32 = json.int32 else {
            // FIXME: Add debugDescription.
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        return int32
    }

    func decode(_ type: Int64.Type) throws -> Int64 {
        guard let int64 = json.int64 else {
            // FIXME: Add debugDescription.
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        return int64
    }

    func decode(_ type: UInt.Type) throws -> UInt {
        guard let uInt = json.uInt else {
            // FIXME: Add debugDescription.
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        return uInt
    }

    func decode(_ type: UInt8.Type) throws -> UInt8 {
        guard let uInt8 = json.uInt8 else {
            // FIXME: Add debugDescription.
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        return uInt8
    }

    func decode(_ type: UInt16.Type) throws -> UInt16 {
        guard let uInt16 = json.uInt16 else {
            // FIXME: Add debugDescription.
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        return uInt16
    }

    func decode(_ type: UInt32.Type) throws -> UInt32 {
        guard let uInt32 = json.uInt32 else {
            // FIXME: Add debugDescription.
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        return uInt32
    }

    func decode(_ type: UInt64.Type) throws -> UInt64 {
        guard let uInt64 = json.uInt64 else {
            // FIXME: Add debugDescription.
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        return uInt64
    }

    func decode(_ type: Float.Type) throws -> Float {
        guard let float = json.float else {
            // FIXME: Add debugDescription.
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        return float
    }

    func decode(_ type: Double.Type) throws -> Double {
        guard let double = json.double else {
            // FIXME: Add debugDescription.
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        return double
    }

    func decode(_ type: String.Type) throws -> String {
        guard let string = json.string else {
            // FIXME: Add debugDescription.
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        return string
    }

    func decode<T: Decodable>(_ type: T.Type) throws -> T {
        decoder.stroage.append(json)
        defer {
            decoder.stroage.removeLast()
        }
        return try T.init(from: decoder)
    }
}
