//
//  UnkeyedDecodingContainer.swift
//  JSON
//
//  Created by 李孛 on 2018/6/15.
//

extension JSON {
    struct UnkeyedDecodingContainer: Swift.UnkeyedDecodingContainer {
        let codingPath: [CodingKey]
        let decoder: JSON._Decoder
        let array: [JSON]

        init(codingPath: [CodingKey], decoder: JSON._Decoder, array: [JSON]) {
            self.codingPath = codingPath
            self.decoder = decoder
            self.array = array
        }

        var currentIndex: Int = 0
        var count: Int? { return array.count }
        var isAtEnd: Bool { return currentIndex >= count! }

        mutating func decodeNil() throws -> Bool {
            guard !isAtEnd else { fatalError() }
            switch array[currentIndex] {
            case .null:
                currentIndex += 1
                return true
            default:
                return false
            }
        }

        mutating func decode(_ type: Bool.Type) throws -> Bool {
            guard !isAtEnd else { fatalError() }
            switch array[currentIndex] {
            case .true:
                currentIndex += 1
                return true
            case .false:
                currentIndex += 1
                return false
            default:
                fatalError()
            }
        }

        mutating func decode(_ type: Int.Type) throws -> Int {
            guard !isAtEnd else { fatalError() }
            switch array[currentIndex] {
            case .number(let number):
                guard let number = number as? Int else { fatalError() }
                currentIndex += 1
                return number
            default:
                fatalError()
            }
        }

        mutating func decode(_ type: Int8.Type) throws -> Int8 {
            guard !isAtEnd else { fatalError() }
            switch array[currentIndex] {
            case .number(let number):
                guard let number = number as? Int8 else { fatalError() }
                currentIndex += 1
                return number
            default:
                fatalError()
            }
        }

        mutating func decode(_ type: Int16.Type) throws -> Int16 {
            guard !isAtEnd else { fatalError() }
            switch array[currentIndex] {
            case .number(let number):
                guard let number = number as? Int16 else { fatalError() }
                currentIndex += 1
                return number
            default:
                fatalError()
            }
        }

        mutating func decode(_ type: Int32.Type) throws -> Int32 {
            guard !isAtEnd else { fatalError() }
            switch array[currentIndex] {
            case .number(let number):
                guard let number = number as? Int32 else { fatalError() }
                currentIndex += 1
                return number
            default:
                fatalError()
            }
        }

        mutating func decode(_ type: Int64.Type) throws -> Int64 {
            guard !isAtEnd else { fatalError() }
            switch array[currentIndex] {
            case .number(let number):
                guard let number = number as? Int64 else { fatalError() }
                currentIndex += 1
                return number
            default:
                fatalError()
            }
        }

        mutating func decode(_ type: UInt.Type) throws -> UInt {
            guard !isAtEnd else { fatalError() }
            switch array[currentIndex] {
            case .number(let number):
                guard let number = number as? UInt else { fatalError() }
                currentIndex += 1
                return number
            default:
                fatalError()
            }
        }

        mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
            guard !isAtEnd else { fatalError() }
            switch array[currentIndex] {
            case .number(let number):
                guard let number = number as? UInt8 else { fatalError() }
                currentIndex += 1
                return number
            default:
                fatalError()
            }
        }

        mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
            guard !isAtEnd else { fatalError() }
            switch array[currentIndex] {
            case .number(let number):
                guard let number = number as? UInt16 else { fatalError() }
                currentIndex += 1
                return number
            default:
                fatalError()
            }
        }

        mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
            guard !isAtEnd else { fatalError() }
            switch array[currentIndex] {
            case .number(let number):
                guard let number = number as? UInt32 else { fatalError() }
                currentIndex += 1
                return number
            default:
                fatalError()
            }
        }

        mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
            guard !isAtEnd else { fatalError() }
            switch array[currentIndex] {
            case .number(let number):
                guard let number = number as? UInt64 else { fatalError() }
                currentIndex += 1
                return number
            default:
                fatalError()
            }
        }

        mutating func decode(_ type: Float.Type) throws -> Float {
            guard !isAtEnd else { fatalError() }
            switch array[currentIndex] {
            case .number(let number):
                guard let number = number as? Float else { fatalError() }
                currentIndex += 1
                return number
            default:
                fatalError()
            }
        }

        mutating func decode(_ type: Double.Type) throws -> Double {
            guard !isAtEnd else { fatalError() }
            switch array[currentIndex] {
            case .number(let number):
                guard let number = number as? Double else { fatalError() }
                currentIndex += 1
                return number
            default:
                fatalError()
            }
        }

        mutating func decode(_ type: String.Type) throws -> String {
            guard !isAtEnd else { fatalError() }
            switch array[currentIndex] {
            case .string(let string):
                currentIndex += 1
                return string
            default:
                fatalError()
            }
        }

        mutating func decode<T: Decodable>(_ type: T.Type) throws -> T {
            guard !isAtEnd else { fatalError() }
            decoder.stroage.append(array[currentIndex])
            defer {
                decoder.stroage.removeLast()
                currentIndex += 1
            }
            return try T.init(from: decoder)
        }

        mutating func nestedContainer<NestedKey: CodingKey>(
            keyedBy type: NestedKey.Type
            ) throws -> Swift.KeyedDecodingContainer<NestedKey> {
            fatalError()
        }

        mutating func nestedUnkeyedContainer() throws -> Swift.UnkeyedDecodingContainer {
            guard !isAtEnd else { fatalError() }
            switch array[currentIndex] {
            case .array(let array):
                currentIndex += 1
                return UnkeyedDecodingContainer(codingPath: codingPath, decoder: decoder, array: array)
            default:
                fatalError()
            }
        }

        mutating func superDecoder() throws -> Swift.Decoder {
            return decoder
        }
    }
}
