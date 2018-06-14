//
//  UnkeyedDecodingContainer.swift
//  JSON
//
//  Created by 李孛 on 2018/6/14.
//

struct _UnkeyedDecodingContainer: UnkeyedDecodingContainer {
    let array: JSON.Array
    let decoder: _JSONDecoder

    init(array: JSON.Array, decoder: _JSONDecoder, codingPath: [CodingKey]) {
        self.array = array
        self.decoder = decoder
        self.codingPath = codingPath
    }

    // MARK: - UnkeyedDecodingContainer

    let codingPath: [CodingKey]
    var currentIndex: Int = 0

    var count: Int? {
        return array.count
    }

    var isAtEnd: Bool {
        return currentIndex >= count!
    }

    mutating func decodeNil() throws -> Bool {
        guard !isAtEnd else {
            fatalError()
        }
        let value = array[currentIndex].isNull
        currentIndex += 1
        return value
    }

    mutating func decode(_ type: Bool.Type) throws -> Bool {
        guard !isAtEnd else {
            fatalError()
        }
        guard let value = array[currentIndex].bool else {
            fatalError()
        }
        currentIndex += 1
        return value
    }

    mutating func decode(_ type: Int.Type) throws -> Int {
        guard !isAtEnd else {
            fatalError()
        }
        guard let value = array[currentIndex].number as? Int else {
            fatalError()
        }
        currentIndex += 1
        return value
    }

    mutating func decode(_ type: Int8.Type) throws -> Int8 {
        guard !isAtEnd else {
            fatalError()
        }
        guard let value = array[currentIndex].number as? Int8 else {
            fatalError()
        }
        currentIndex += 1
        return value
    }

    mutating func decode(_ type: Int16.Type) throws -> Int16 {
        guard !isAtEnd else {
            fatalError()
        }
        guard let value = array[currentIndex].number as? Int16 else {
            fatalError()
        }
        currentIndex += 1
        return value
    }

    mutating func decode(_ type: Int32.Type) throws -> Int32 {
        guard !isAtEnd else {
            fatalError()
        }
        guard let value = array[currentIndex].number as? Int32 else {
            fatalError()
        }
        currentIndex += 1
        return value
    }

    mutating func decode(_ type: Int64.Type) throws -> Int64 {
        guard !isAtEnd else {
            fatalError()
        }
        guard let value = array[currentIndex].number as? Int64 else {
            fatalError()
        }
        currentIndex += 1
        return value
    }

    mutating func decode(_ type: UInt.Type) throws -> UInt {
        guard !isAtEnd else {
            fatalError()
        }
        guard let value = array[currentIndex].number as? UInt else {
            fatalError()
        }
        currentIndex += 1
        return value
    }

    mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
        guard !isAtEnd else {
            fatalError()
        }
        guard let value = array[currentIndex].number as? UInt8 else {
            fatalError()
        }
        currentIndex += 1
        return value
    }

    mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
        guard !isAtEnd else {
            fatalError()
        }
        guard let value = array[currentIndex].number as? UInt16 else {
            fatalError()
        }
        currentIndex += 1
        return value
    }

    mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
        guard !isAtEnd else {
            fatalError()
        }
        guard let value = array[currentIndex].number as? UInt32 else {
            fatalError()
        }
        currentIndex += 1
        return value
    }

    mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
        guard !isAtEnd else {
            fatalError()
        }
        guard let value = array[currentIndex].number as? UInt64 else {
            fatalError()
        }
        currentIndex += 1
        return value
    }

    mutating func decode(_ type: Float.Type) throws -> Float {
        guard !isAtEnd else {
            fatalError()
        }
        guard let value = array[currentIndex].number as? Float else {
            fatalError()
        }
        currentIndex += 1
        return value
    }

    mutating func decode(_ type: Double.Type) throws -> Double {
        guard !isAtEnd else {
            fatalError()
        }
        guard let value = array[currentIndex].number as? Double else {
            fatalError()
        }
        currentIndex += 1
        return value
    }

    mutating func decode(_ type: String.Type) throws -> String {
        guard !isAtEnd else {
            fatalError()
        }
        guard let value = array[currentIndex].string else {
            fatalError()
        }
        currentIndex += 1
        return value
    }

    mutating func decode<T: Decodable>(_ type: T.Type) throws -> T {
        guard !isAtEnd else {
            fatalError()
        }
        decoder.stroage.append(array[currentIndex])
        defer {
            decoder.stroage.removeLast()
        }
        return try T.init(from: decoder)
    }

    mutating func nestedContainer<NestedKey: CodingKey>(
        keyedBy type: NestedKey.Type
    ) throws -> KeyedDecodingContainer<NestedKey> {
        guard !isAtEnd else {
            fatalError()
        }
        let json = array[currentIndex]
        decoder.stroage.append(json)
        defer {
            decoder.stroage.removeLast()
        }
        guard let object = json.object else {
            fatalError()
        }
        return KeyedDecodingContainer(_KeyedDecodingContainer(object: object, decoder: decoder, codingPath: codingPath))
    }

    mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        guard !isAtEnd else {
            fatalError()
        }
        let json = array[currentIndex]
        decoder.stroage.append(json)
        defer {
            decoder.stroage.removeLast()
        }
        guard let array = json.array else {
            fatalError()
        }
        return _UnkeyedDecodingContainer(array: array, decoder: decoder, codingPath: codingPath)
    }

    mutating func superDecoder() throws -> Decoder {
        return decoder
    }

}
