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
        guard let value = json.number as? Int else {
            // FIXME: Add debugDescription.
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        return value
    }

    func decode(_ type: Int8.Type) throws -> Int8 {
        guard let value = json.number as? Int8 else {
            // FIXME: Add debugDescription.
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        return value
    }

    func decode(_ type: Int16.Type) throws -> Int16 {
        guard let value = json.number as? Int16 else {
            // FIXME: Add debugDescription.
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        return value

    }

    func decode(_ type: Int32.Type) throws -> Int32 {
        guard let value = json.number as? Int32 else {
            // FIXME: Add debugDescription.
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        return value

    }

    func decode(_ type: Int64.Type) throws -> Int64 {
        guard let value = json.number as? Int64 else {
            // FIXME: Add debugDescription.
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        return value

    }

    func decode(_ type: UInt.Type) throws -> UInt {
        guard let value = json.number as? UInt else {
            // FIXME: Add debugDescription.
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        return value
    }

    func decode(_ type: UInt8.Type) throws -> UInt8 {
        guard let value = json.number as? UInt8 else {
            // FIXME: Add debugDescription.
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        return value
    }

    func decode(_ type: UInt16.Type) throws -> UInt16 {
        guard let value = json.number as? UInt16 else {
            // FIXME: Add debugDescription.
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        return value
    }

    func decode(_ type: UInt32.Type) throws -> UInt32 {
        guard let value = json.number as? UInt32 else {
            // FIXME: Add debugDescription.
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        return value
    }

    func decode(_ type: UInt64.Type) throws -> UInt64 {
        guard let value = json.number as? UInt64 else {
            // FIXME: Add debugDescription.
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        return value
    }

    func decode(_ type: Float.Type) throws -> Float {
        guard let value = json.number as? Float else {
            // FIXME: Add debugDescription.
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        return value
    }

    func decode(_ type: Double.Type) throws -> Double {
        guard let value = json.number as? Double else {
            // FIXME: Add debugDescription.
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        return value
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
