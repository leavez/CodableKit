//
//  KeyedDecodingContainer.swift
//  CodableKit
//
//  Created by 李孛 on 2018/6/15.
//

extension JSON {
    struct KeyedDecodingContainer<Key: CodingKey> {
        let codingPath: [CodingKey]
        let decoder: JSON._Decoder
        let object: [String: JSON]
    }
}

extension JSON.KeyedDecodingContainer {
    private func stringValue(forKey key: CodingKey) -> String {
        switch decoder.options.keyDecodingStrategy {
        case .useDefaultKeys:
            return key.stringValue
        case .convertFromSnakeCase:
            return key.stringValue.snakeCased()
        }
    }

    private func value(forKey key: CodingKey) throws -> JSON {
        let stringKey = stringValue(forKey: key)
        guard let value = object[stringKey] else {
            let description = "No value associated with key \(key) (\"\(stringKey)\"."
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
            throw DecodingError.keyNotFound(key, context)
        }
        return value
    }
}

extension JSON.KeyedDecodingContainer: KeyedDecodingContainerProtocol {
    var allKeys: [Key] {
        return object.keys.compactMap(Key.init)
    }

    func contains(_ key: Key) -> Bool {
        return object.keys.contains(stringValue(forKey: key))
    }

    func decodeNil(forKey key: Key) throws -> Bool {
        let value = try self.value(forKey: key)
        return value.isNull
    }

    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        let value = try self.value(forKey: key)
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        return try decoder.unbox(value, as: type)
    }

    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        let value = try self.value(forKey: key)
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        return try decoder.unbox(value, as: type)
    }

    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        let value = try self.value(forKey: key)
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        return try decoder.unbox(value, as: type)
    }

    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        let value = try self.value(forKey: key)
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        return try decoder.unbox(value, as: type)
    }

    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        let value = try self.value(forKey: key)
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        return try decoder.unbox(value, as: type)
    }

    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        let value = try self.value(forKey: key)
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        return try decoder.unbox(value, as: type)
    }

    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        let value = try self.value(forKey: key)
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        return try decoder.unbox(value, as: type)
    }

    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        let value = try self.value(forKey: key)
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        return try decoder.unbox(value, as: type)
    }

    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        let value = try self.value(forKey: key)
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        return try decoder.unbox(value, as: type)
    }

    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        let value = try self.value(forKey: key)
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        return try decoder.unbox(value, as: type)
    }

    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        let value = try self.value(forKey: key)
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        return try decoder.unbox(value, as: type)
    }

    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        let value = try self.value(forKey: key)
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        return try decoder.unbox(value, as: type)
    }

    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        let value = try self.value(forKey: key)
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        return try decoder.unbox(value, as: type)
    }

    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        let value = try self.value(forKey: key)
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        return try decoder.unbox(value, as: type)
    }

    func decode<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
        let value = try self.value(forKey: key)
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        return try decoder.unbox(value, as: type)
    }

    func nestedContainer<NestedKey: CodingKey>(
        keyedBy type: NestedKey.Type,
        forKey key: Key
    ) throws -> KeyedDecodingContainer<NestedKey> {
        let value = try self.value(forKey: key)
        let codingPath = self.codingPath + [key]
        guard let object = value.object else {
            throw DecodingError._typeMismatch(at: codingPath, expectation: [String: JSON].self, reality: value)
        }
        let container = JSON.KeyedDecodingContainer<NestedKey>(codingPath: codingPath, decoder: decoder, object: object)
        return KeyedDecodingContainer(container)
    }

    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        let value = try self.value(forKey: key)
        let codingPath = self.codingPath + [key]
        guard let array = value.array else {
            throw DecodingError._typeMismatch(at: codingPath, expectation: [JSON].self, reality: value)
        }
        return JSON.UnkeyedDecodingContainer(codingPath: codingPath, decoder: decoder, array: array)
    }

    func superDecoder() throws -> Decoder {
        return try _superDecoder(forKey: AnyCodingKey.super)
    }

    func superDecoder(forKey key: Key) throws -> Decoder {
        return try _superDecoder(forKey: key)
    }

    private func _superDecoder(forKey key: CodingKey) throws -> Decoder {
        let value = try self.value(forKey: key)
        let decoder = JSON._Decoder(codingPath: codingPath + [key], options: self.decoder.options)
        decoder.stroage.append(value)
        return decoder
    }
}
