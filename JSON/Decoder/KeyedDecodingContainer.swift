//
//  KeyedDecodingContainer.swift
//  JSON
//
//  Created by 李孛 on 2018/6/14.
//

struct _KeyedDecodingContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
    let json: JSON
    let decoder: _JSONDecoder

    init(json: JSON, decoder: _JSONDecoder, codingPath: [CodingKey]) {
        self.json = json
        self.decoder = decoder
        self.codingPath = codingPath
    }

    let codingPath: [CodingKey]

    var allKeys: [Key] {
        return self.json.object!.keys.compactMap(Key.init)
    }

    func contains(_ key: Key) -> Bool {
        return self.json.object?.keys.contains(key.stringValue) == true
    }

    func decodeNil(forKey key: Key) throws -> Bool {
        return self.json.object?[key.stringValue]?.isNull == true
    }

    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        fatalError()
    }

    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        fatalError()
    }

    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        fatalError()
    }

    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        fatalError()
    }

    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        fatalError()
    }

    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        fatalError()
    }

    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        fatalError()
    }

    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        fatalError()
    }

    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        fatalError()
    }

    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        fatalError()
    }

    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        fatalError()
    }

    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        fatalError()
    }

    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        fatalError()
    }

    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        fatalError()
    }

    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
        fatalError()
    }

    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError()
    }

    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        fatalError()
    }

    func superDecoder() throws -> Decoder {
        fatalError()
    }

    func superDecoder(forKey key: Key) throws -> Decoder {
        fatalError()
    }

}
