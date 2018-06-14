//
//  KeyedDecodingContainer.swift
//  JSON
//
//  Created by 李孛 on 2018/6/14.
//

struct _KeyedDecodingContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
    let object: JSON.Object
    let decoder: _JSONDecoder

    init(object: JSON.Object, decoder: _JSONDecoder, codingPath: [CodingKey]) {
        self.object = object
        self.decoder = decoder
        self.codingPath = codingPath
    }

    // MARK: - KeyedDecodingContainerProtocol

    let codingPath: [CodingKey]

    var allKeys: [Key] {
        return object.keys.compactMap(Key.init)
    }

    func contains(_ key: Key) -> Bool {
        return object.keys.contains(key.stringValue)
    }

    func decodeNil(forKey key: Key) throws -> Bool {
        guard let json = object[key.stringValue] else {
            fatalError()
        }
        return json.isNull
    }

    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        guard let json = object[key.stringValue] else {
            fatalError()
        }
        guard let value = json.bool else {
            fatalError()
        }
        return value
    }

    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        guard let json = object[key.stringValue] else {
            fatalError()
        }
        guard let value = json.number as? Int else {
            fatalError()
        }
        return value
    }

    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        guard let json = object[key.stringValue] else {
            fatalError()
        }
        guard let value = json.number as? Int8 else {
            fatalError()
        }
        return value
    }

    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        guard let json = object[key.stringValue] else {
            fatalError()
        }
        guard let value = json.number as? Int16 else {
            fatalError()
        }
        return value
    }

    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        guard let json = object[key.stringValue] else {
            fatalError()
        }
        guard let value = json.number as? Int32 else {
            fatalError()
        }
        return value
    }

    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        guard let json = object[key.stringValue] else {
            fatalError()
        }
        guard let value = json.number as? Int64 else {
            fatalError()
        }
        return value
    }

    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        guard let json = object[key.stringValue] else {
            fatalError()
        }
        guard let value = json.number as? UInt else {
            fatalError()
        }
        return value
    }

    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        guard let json = object[key.stringValue] else {
            fatalError()
        }
        guard let value = json.number as? UInt8 else {
            fatalError()
        }
        return value
    }

    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        guard let json = object[key.stringValue] else {
            fatalError()
        }
        guard let value = json.number as? UInt16 else {
            fatalError()
        }
        return value
    }

    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        guard let json = object[key.stringValue] else {
            fatalError()
        }
        guard let value = json.number as? UInt32 else {
            fatalError()
        }
        return value
    }

    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        guard let json = object[key.stringValue] else {
            fatalError()
        }
        guard let value = json.number as? UInt64 else {
            fatalError()
        }
        return value
    }

    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        guard let json = object[key.stringValue] else {
            fatalError()
        }
        guard let value = json.number as? Float else {
            fatalError()
        }
        return value
    }

    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        guard let json = object[key.stringValue] else {
            fatalError()
        }
        guard let value = json.number as? Double else {
            fatalError()
        }
        return value
    }

    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        guard let json = object[key.stringValue] else {
            fatalError()
        }
        guard let value = json.string else {
            fatalError()
        }
        return value
    }

    func decode<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
        guard let json = object[key.stringValue] else {
            fatalError()
        }
        decoder.stroage.append(json)
        decoder.codingPath.append(key)
        defer {
            decoder.stroage.removeLast()
            decoder.codingPath.removeLast()
        }
        return try T.init(from: decoder)
    }

    func nestedContainer<NestedKey: CodingKey>(
        keyedBy type: NestedKey.Type,
        forKey key: Key
    ) throws -> KeyedDecodingContainer<NestedKey> {
        guard let json = self.object[key.stringValue] else {
            fatalError()
        }
        decoder.stroage.append(json)
        decoder.codingPath.append(key)
        defer {
            decoder.stroage.removeLast()
            decoder.codingPath.removeLast()
        }
        guard let object = json.object else {
            fatalError()
        }
        return KeyedDecodingContainer(
            _KeyedDecodingContainer<NestedKey>(
                object: object,
                decoder: decoder,
                codingPath: decoder.codingPath
            )
        )
    }

    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        fatalError()
    }

    func superDecoder() throws -> Decoder {
        return decoder
    }

    func superDecoder(forKey key: Key) throws -> Decoder {
        return decoder
    }
}
