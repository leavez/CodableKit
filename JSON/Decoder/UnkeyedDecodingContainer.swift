//
//  UnkeyedDecodingContainer.swift
//  JSON
//
//  Created by 李孛 on 2018/6/14.
//

struct _UnkeyedDecodingContainer: UnkeyedDecodingContainer {
    let json: JSON
    let decoder: _JSONDecoder

    init(json: JSON, decoder: _JSONDecoder, codingPath: [CodingKey]) {
        self.json = json
        self.decoder = decoder
        self.codingPath = codingPath
    }

    let codingPath: [CodingKey]

    var currentIndex: Int = 0

    var count: Int? {
        return json.array?.count
    }

    var isAtEnd: Bool {
        return currentIndex == count
    }

    mutating func decodeNil() throws -> Bool {
        if json.array?[currentIndex].isNull == true {
            currentIndex += 1
            return true
        } else {
            return false
        }
    }

    mutating func decode(_ type: Bool.Type) throws -> Bool {
        if json.array?[currentIndex].isTrue == true {
            currentIndex += 1
            return true
        }
        if json.array?[currentIndex].isFalse == true {
            currentIndex += 1
            return false
        }
        // FIXME:
        throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
    }

    mutating func decode(_ type: Int.Type) throws -> Int {
        guard let value = json.array?[currentIndex].number as? Int else {
            // FIXME:
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        currentIndex += 1
        return value
    }

    mutating func decode(_ type: Int8.Type) throws -> Int8 {
        guard let value = json.array?[currentIndex].number as? Int8 else {
            // FIXME:
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        currentIndex += 1
        return value

    }

    mutating func decode(_ type: Int16.Type) throws -> Int16 {
        guard let value = json.array?[currentIndex].number as? Int16 else {
            // FIXME:
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        currentIndex += 1
        return value

    }

    mutating func decode(_ type: Int32.Type) throws -> Int32 {
        guard let value = json.array?[currentIndex].number as? Int32 else {
            // FIXME:
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        currentIndex += 1
        return value

    }

    mutating func decode(_ type: Int64.Type) throws -> Int64 {
        guard let value = json.array?[currentIndex].number as? Int64 else {
            // FIXME:
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        currentIndex += 1
        return value

    }

    mutating func decode(_ type: UInt.Type) throws -> UInt {
        guard let value = json.array?[currentIndex].number as? UInt else {
            // FIXME:
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        currentIndex += 1
        return value
    }

    mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
        guard let value = json.array?[currentIndex].number as? UInt8 else {
            // FIXME:
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        currentIndex += 1
        return value
    }

    mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
        guard let value = json.array?[currentIndex].number as? UInt16 else {
            // FIXME:
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        currentIndex += 1
        return value
    }

    mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
        guard let value = json.array?[currentIndex].number as? UInt32 else {
            // FIXME:
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        currentIndex += 1
        return value
    }

    mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
        guard let value = json.array?[currentIndex].number as? UInt64 else {
            // FIXME:
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        currentIndex += 1
        return value
    }

    mutating func decode(_ type: Float.Type) throws -> Float {
        guard let value = json.array?[currentIndex].number as? Float else {
            // FIXME:
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        currentIndex += 1
        return value
    }

    mutating func decode(_ type: Double.Type) throws -> Double {
        guard let value = json.array?[currentIndex].number as? Double else {
            // FIXME:
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        currentIndex += 1
        return value
    }

    mutating func decode(_ type: String.Type) throws -> String {
        guard let value = json.array?[currentIndex].string else {
            // FIXME:
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        currentIndex += 1
        return value
    }

    mutating func decode<T: Decodable>(_ type: T.Type) throws -> T {
        guard let json = self.json.array?[currentIndex] else {
            // FIXME:
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: ""))
        }
        decoder.stroage.append(json)
        defer {
            decoder.stroage.removeLast()
        }
        let value = try T.init(from: decoder)
        currentIndex += 1
        return value
    }

    mutating func nestedContainer<NestedKey: CodingKey>(
        keyedBy type: NestedKey.Type
    ) throws -> KeyedDecodingContainer<NestedKey> {
        fatalError()
    }

    mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        guard let json = self.json.array?[currentIndex] else {
            // FIXME:
            throw DecodingError.dataCorruptedError(in: self, debugDescription: "")
        }
        currentIndex += 1
        return _UnkeyedDecodingContainer(json: json, decoder: decoder, codingPath: codingPath)
    }

    mutating func superDecoder() throws -> Decoder {
        fatalError()
    }

}
