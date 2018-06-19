//
//  UnkeyedDecodingContainer.swift
//  JSON
//
//  Created by 李孛 on 2018/6/15.
//

fileprivate struct _JSONKey: CodingKey {
    let stringValue: String
    let intValue: Int?

    init?(stringValue: String) { fatalError() }
    init?(intValue: Int) { fatalError() }

    fileprivate init(index: Int) {
        self.stringValue = "Index \(index)"
        self.intValue = index
    }
}

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
            let codingPath = self.codingPath + [_JSONKey(index: currentIndex)]
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
        } else {
            return false
        }
    }

    mutating func decode(_ type: Bool.Type) throws -> Bool {
        try expectNotAtEnd(for: type)
        decoder.codingPath.append(_JSONKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }
        let result = try decoder.unbox(array[currentIndex], as: type)
        currentIndex += 1
        return result
    }

    mutating func decode(_ type: Int.Type) throws -> Int {
        try expectNotAtEnd(for: type)
        decoder.codingPath.append(_JSONKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }
        let result = try decoder.unbox(array[currentIndex], as: type)
        currentIndex += 1
        return result
    }

    mutating func decode(_ type: Int8.Type) throws -> Int8 {
        try expectNotAtEnd(for: type)
        decoder.codingPath.append(_JSONKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }
        let result = try decoder.unbox(array[currentIndex], as: type)
        currentIndex += 1
        return result
    }

    mutating func decode(_ type: Int16.Type) throws -> Int16 {
        try expectNotAtEnd(for: type)
        decoder.codingPath.append(_JSONKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }
        let result = try decoder.unbox(array[currentIndex], as: type)
        currentIndex += 1
        return result
    }

    mutating func decode(_ type: Int32.Type) throws -> Int32 {
        try expectNotAtEnd(for: type)
        decoder.codingPath.append(_JSONKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }
        let result = try decoder.unbox(array[currentIndex], as: type)
        currentIndex += 1
        return result
    }

    mutating func decode(_ type: Int64.Type) throws -> Int64 {
        try expectNotAtEnd(for: type)
        decoder.codingPath.append(_JSONKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }
        let result = try decoder.unbox(array[currentIndex], as: type)
        currentIndex += 1
        return result
    }

    mutating func decode(_ type: UInt.Type) throws -> UInt {
        try expectNotAtEnd(for: type)
        decoder.codingPath.append(_JSONKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }
        let result = try decoder.unbox(array[currentIndex], as: type)
        currentIndex += 1
        return result
    }

    mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
        try expectNotAtEnd(for: type)
        decoder.codingPath.append(_JSONKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }
        let result = try decoder.unbox(array[currentIndex], as: type)
        currentIndex += 1
        return result
    }

    mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
        try expectNotAtEnd(for: type)
        decoder.codingPath.append(_JSONKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }
        let result = try decoder.unbox(array[currentIndex], as: type)
        currentIndex += 1
        return result
    }

    mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
        try expectNotAtEnd(for: type)
        decoder.codingPath.append(_JSONKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }
        let result = try decoder.unbox(array[currentIndex], as: type)
        currentIndex += 1
        return result
    }

    mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
        try expectNotAtEnd(for: type)
        decoder.codingPath.append(_JSONKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }
        let result = try decoder.unbox(array[currentIndex], as: type)
        currentIndex += 1
        return result
    }

    mutating func decode(_ type: Float.Type) throws -> Float {
        try expectNotAtEnd(for: type)
        decoder.codingPath.append(_JSONKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }
        let result = try decoder.unbox(array[currentIndex], as: type)
        currentIndex += 1
        return result
    }

    mutating func decode(_ type: Double.Type) throws -> Double {
        try expectNotAtEnd(for: type)
        decoder.codingPath.append(_JSONKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }
        let result = try decoder.unbox(array[currentIndex], as: type)
        currentIndex += 1
        return result
    }

    mutating func decode(_ type: String.Type) throws -> String {
        try expectNotAtEnd(for: type)
        decoder.codingPath.append(_JSONKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }
        let result = try decoder.unbox(array[currentIndex], as: type)
        currentIndex += 1
        return result
    }

    mutating func decode<T: Decodable>(_ type: T.Type) throws -> T {
        try expectNotAtEnd(for: type)
        decoder.codingPath.append(_JSONKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }
        let result = try decoder.unbox(array[currentIndex], as: type)
        currentIndex += 1
        return result
    }

    mutating func nestedContainer<NestedKey: CodingKey>(
        keyedBy type: NestedKey.Type
    ) throws -> KeyedDecodingContainer<NestedKey> {
        guard !isAtEnd else {
            let description = "Cannot get nested keyed container -- unkeyed container is at end."
            let context = DecodingError.Context(codingPath: self.codingPath, debugDescription: description)
            throw DecodingError.valueNotFound(KeyedDecodingContainer<NestedKey>.self, context)
        }
        let value = array[currentIndex]
        guard !value.isNull else {
            let description = "Cannot get keyed decoding container -- found null value instead."
            let context = DecodingError.Context(codingPath: self.codingPath, debugDescription: description)
            throw DecodingError.valueNotFound(KeyedDecodingContainer<NestedKey>.self, context)
        }
        let codingPath = self.codingPath + [_JSONKey(index: currentIndex)]
        guard let object = value.object else {
            throw DecodingError._typeMismatch(at: codingPath, expectation: [String: JSON].self, reality: value)
        }
        currentIndex += 1
        let container = JSON.KeyedDecodingContainer<NestedKey>(codingPath: codingPath, decoder: decoder, object: object)
        return KeyedDecodingContainer(container)
    }

    mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        guard !isAtEnd else {
            let description = "Cannot get nested unkeyed container -- unkeyed container is at end."
            let context = DecodingError.Context(codingPath: self.codingPath, debugDescription: description)
            throw DecodingError.valueNotFound(UnkeyedDecodingContainer.self, context)
        }
        let value = array[currentIndex]
        guard !value.isNull else {
            let description = "Cannot get keyed decoding container -- found null value instead."
            let context = DecodingError.Context(codingPath: self.codingPath, debugDescription: description)
            throw DecodingError.valueNotFound(UnkeyedDecodingContainer.self, context)
        }
        let codingPath = self.codingPath + [_JSONKey(index: currentIndex)]
        guard let array = value.array else {
            throw DecodingError._typeMismatch(at: codingPath, expectation: [JSON].self, reality: value)
        }
        currentIndex += 1
        return JSON.UnkeyedDecodingContainer(codingPath: codingPath, decoder: decoder, array: array)
    }

    mutating func superDecoder() throws -> Decoder {
        guard !isAtEnd else {
            let description = "Cannot get superDecoder() -- unkeyed container is at end."
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
            throw DecodingError.valueNotFound(Decoder.self, context)
        }
        return decoder
    }
}
