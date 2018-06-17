//
//  KeyedDecodingContainer.swift
//  JSON
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
    private func value(forKey key: Key) throws -> JSON {
        guard let value = object[key.stringValue] else {
            let description = "No value associated with key \(key) (\"\(key.stringValue)\"."
            throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: codingPath,
                                                                       debugDescription: description))
        }
        return value
    }
}

extension JSON.KeyedDecodingContainer: KeyedDecodingContainerProtocol {
    var allKeys: [Key] {
        return object.keys.compactMap(Key.init)
    }

    func contains(_ key: Key) -> Bool {
        return object.keys.contains(key.stringValue)
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
        switch value {
        case .object(let object):
            return KeyedDecodingContainer(JSON.KeyedDecodingContainer<NestedKey>(codingPath: codingPath,
                                                                                 decoder: decoder,
                                                                                 object: object))
        default:
            throw DecodingError._typeMismatch(at: codingPath,
                                              expectation: [String: JSON].self,
                                              reality: value)
        }
    }

    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        let value = try self.value(forKey: key)
        let codingPath = self.codingPath + [key]
        switch value {
        case .array(let array):
            return JSON.UnkeyedDecodingContainer(codingPath: codingPath, decoder: decoder, array: array)
        default:
            throw DecodingError._typeMismatch(at: codingPath, expectation: [JSON].self, reality: value)
        }
    }

    func superDecoder() throws -> Decoder {
        return decoder
    }

    func superDecoder(forKey key: Key) throws -> Decoder {
        let value = try self.value(forKey: key)
        return JSON._Decoder(codingPath: codingPath + [key], userInfo: decoder.userInfo, value: value)
    }
}
