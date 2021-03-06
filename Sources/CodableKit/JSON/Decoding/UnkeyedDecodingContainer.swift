//
//  UnkeyedDecodingContainer.swift
//  CodableKit
//
//  Created by 李孛 on 2018/6/15.
//

extension JSON {
    struct UnkeyedDecodingContainer {
        let codingPath: [CodingKey]
        let decoder: JSON._Decoder
        let array: [JSON]

        init(codingPath: [CodingKey], decoder: JSON._Decoder, array: [JSON]) {
            self.codingPath = codingPath
            self.decoder = decoder
            self.array = array
        }

        var currentIndex: Int = 0
    }
}

extension JSON.UnkeyedDecodingContainer {
    private func expectNotAtEnd<T>(for type: T.Type) throws {
        guard !isAtEnd else {
            let codingPath = self.codingPath + [AnyCodingKey(index: currentIndex)]
            let description = "Unkeyed container is at end."
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
            throw DecodingError.valueNotFound(type, context)
        }
    }
}

extension JSON.UnkeyedDecodingContainer: UnkeyedDecodingContainer {
    var count: Int? { return array.count }
    var isAtEnd: Bool { return currentIndex >= count! }

    mutating func decodeNil() throws -> Bool {
        try expectNotAtEnd(for: Any?.self)
        if array[currentIndex].isNull {
            currentIndex += 1
            return true
        }
        return false
    }

    mutating func decode(_ type: Bool.Type) throws -> Bool {
        try expectNotAtEnd(for: type)
        decoder.codingPath.append(AnyCodingKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }
        let result = try decoder.unbox(array[currentIndex], as: type)
        currentIndex += 1
        return result
    }

    mutating func decode(_ type: Int.Type) throws -> Int {
        try expectNotAtEnd(for: type)
        decoder.codingPath.append(AnyCodingKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }
        let result = try decoder.unbox(array[currentIndex], as: type)
        currentIndex += 1
        return result
    }

    mutating func decode(_ type: Int8.Type) throws -> Int8 {
        try expectNotAtEnd(for: type)
        decoder.codingPath.append(AnyCodingKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }
        let result = try decoder.unbox(array[currentIndex], as: type)
        currentIndex += 1
        return result
    }

    mutating func decode(_ type: Int16.Type) throws -> Int16 {
        try expectNotAtEnd(for: type)
        decoder.codingPath.append(AnyCodingKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }
        let result = try decoder.unbox(array[currentIndex], as: type)
        currentIndex += 1
        return result
    }

    mutating func decode(_ type: Int32.Type) throws -> Int32 {
        try expectNotAtEnd(for: type)
        decoder.codingPath.append(AnyCodingKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }
        let result = try decoder.unbox(array[currentIndex], as: type)
        currentIndex += 1
        return result
    }

    mutating func decode(_ type: Int64.Type) throws -> Int64 {
        try expectNotAtEnd(for: type)
        decoder.codingPath.append(AnyCodingKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }
        let result = try decoder.unbox(array[currentIndex], as: type)
        currentIndex += 1
        return result
    }

    mutating func decode(_ type: UInt.Type) throws -> UInt {
        try expectNotAtEnd(for: type)
        decoder.codingPath.append(AnyCodingKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }
        let result = try decoder.unbox(array[currentIndex], as: type)
        currentIndex += 1
        return result
    }

    mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
        try expectNotAtEnd(for: type)
        decoder.codingPath.append(AnyCodingKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }
        let result = try decoder.unbox(array[currentIndex], as: type)
        currentIndex += 1
        return result
    }

    mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
        try expectNotAtEnd(for: type)
        decoder.codingPath.append(AnyCodingKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }
        let result = try decoder.unbox(array[currentIndex], as: type)
        currentIndex += 1
        return result
    }

    mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
        try expectNotAtEnd(for: type)
        decoder.codingPath.append(AnyCodingKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }
        let result = try decoder.unbox(array[currentIndex], as: type)
        currentIndex += 1
        return result
    }

    mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
        try expectNotAtEnd(for: type)
        decoder.codingPath.append(AnyCodingKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }
        let result = try decoder.unbox(array[currentIndex], as: type)
        currentIndex += 1
        return result
    }

    mutating func decode(_ type: Float.Type) throws -> Float {
        try expectNotAtEnd(for: type)
        decoder.codingPath.append(AnyCodingKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }
        let result = try decoder.unbox(array[currentIndex], as: type)
        currentIndex += 1
        return result
    }

    mutating func decode(_ type: Double.Type) throws -> Double {
        try expectNotAtEnd(for: type)
        decoder.codingPath.append(AnyCodingKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }
        let result = try decoder.unbox(array[currentIndex], as: type)
        currentIndex += 1
        return result
    }

    mutating func decode(_ type: String.Type) throws -> String {
        try expectNotAtEnd(for: type)
        decoder.codingPath.append(AnyCodingKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }
        let result = try decoder.unbox(array[currentIndex], as: type)
        currentIndex += 1
        return result
    }

    mutating func decode<T: Decodable>(_ type: T.Type) throws -> T {
        try expectNotAtEnd(for: type)
        decoder.codingPath.append(AnyCodingKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }
        let result = try decoder.unbox(array[currentIndex], as: type)
        currentIndex += 1
        return result
    }

    mutating func nestedContainer<NestedKey: CodingKey>(
        keyedBy type: NestedKey.Type
    ) throws -> KeyedDecodingContainer<NestedKey> {
        try expectNotAtEnd(for: KeyedDecodingContainer<NestedKey>.self)
        let value = array[currentIndex]
        let codingPath = self.codingPath + [AnyCodingKey(index: currentIndex)]
        guard let object = value.object else {
            throw DecodingError._typeMismatch(at: codingPath, expectation: [String: JSON].self, reality: value)
        }
        currentIndex += 1
        let container = JSON.KeyedDecodingContainer<NestedKey>(codingPath: codingPath, decoder: decoder, object: object)
        return KeyedDecodingContainer(container)
    }

    mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        try expectNotAtEnd(for: UnkeyedDecodingContainer.self)
        let value = array[currentIndex]
        let codingPath = self.codingPath + [AnyCodingKey(index: currentIndex)]
        guard let array = value.array else {
            throw DecodingError._typeMismatch(at: codingPath, expectation: [JSON].self, reality: value)
        }
        currentIndex += 1
        return JSON.UnkeyedDecodingContainer(codingPath: codingPath, decoder: decoder, array: array)
    }

    mutating func superDecoder() throws -> Decoder {
        try expectNotAtEnd(for: Decoder.self)
        let decoder = JSON._Decoder(codingPath: codingPath + [AnyCodingKey(index: currentIndex)],
                                    options: self.decoder.options)
        decoder.stroage.append(array[currentIndex])
        currentIndex += 1
        return decoder
    }
}
