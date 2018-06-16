//
//  KeyedDecodingContainer.swift
//  JSON
//
//  Created by 李孛 on 2018/6/15.
//

extension JSON {
    struct KeyedDecodingContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
        let codingPath: [CodingKey]
        let decoder: JSON._Decoder
        let object: [String: JSON]
        var allKeys: [Key] { return object.keys.compactMap(Key.init) }

        func contains(_ key: Key) -> Bool {
            return object.keys.contains(key.stringValue)
        }

        func decodeNil(forKey key: Key) throws -> Bool {
            guard let value = object[key.stringValue] else { fatalError() }
            switch value {
            case .null:
                return true
            default:
                return false
            }
        }

        func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
            guard let value = object[key.stringValue] else { fatalError() }
            switch value {
            case .true:
                return true
            case .false:
                return false
            default:
                fatalError()
            }
        }

        func decode(_ type: String.Type, forKey key: Key) throws -> String {
            guard let value = object[key.stringValue] else { fatalError() }
            switch value {
            case .string(let string):
                return string
            default:
                fatalError()
            }
        }

        func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
            guard let value = object[key.stringValue] else { fatalError() }
            switch value {
            case .number(let number):
                guard let number = number as? Double else { fatalError() }
                return number
            default:
                fatalError()
            }
        }

        func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
            guard let value = object[key.stringValue] else { fatalError() }
            switch value {
            case .number(let number):
                guard let number = number as? Float else { fatalError() }
                return number
            default:
                fatalError()
            }
        }

        func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
            guard let value = object[key.stringValue] else { fatalError() }
            switch value {
            case .number(let number):
                guard let number = number as? Int else { fatalError() }
                return number
            default:
                fatalError()
            }
        }

        func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
            guard let value = object[key.stringValue] else { fatalError() }
            switch value {
            case .number(let number):
                guard let number = number as? Int8 else { fatalError() }
                return number
            default:
                fatalError()
            }
        }

        func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
            guard let value = object[key.stringValue] else { fatalError() }
            switch value {
            case .number(let number):
                guard let number = number as? Int16 else { fatalError() }
                return number
            default:
                fatalError()
            }
        }

        func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
            guard let value = object[key.stringValue] else { fatalError() }
            switch value {
            case .number(let number):
                guard let number = number as? Int32 else { fatalError() }
                return number
            default:
                fatalError()
            }
        }

        func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
            guard let value = object[key.stringValue] else { fatalError() }
            switch value {
            case .number(let number):
                guard let number = number as? Int64 else { fatalError() }
                return number
            default:
                fatalError()
            }
        }

        func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
            guard let value = object[key.stringValue] else { fatalError() }
            switch value {
            case .number(let number):
                guard let number = number as? UInt else { fatalError() }
                return number
            default:
                fatalError()
            }
        }

        func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
            guard let value = object[key.stringValue] else { fatalError() }
            switch value {
            case .number(let number):
                guard let number = number as? UInt8 else { fatalError() }
                return number
            default:
                fatalError()
            }
        }

        func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
            guard let value = object[key.stringValue] else { fatalError() }
            switch value {
            case .number(let number):
                guard let number = number as? UInt16 else { fatalError() }
                return number
            default:
                fatalError()
            }
        }

        func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
            guard let value = object[key.stringValue] else { fatalError() }
            switch value {
            case .number(let number):
                guard let number = number as? UInt32 else { fatalError() }
                return number
            default:
                fatalError()
            }
        }

        func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
            guard let value = object[key.stringValue] else { fatalError() }
            switch value {
            case .number(let number):
                guard let number = number as? UInt64 else { fatalError() }
                return number
            default:
                fatalError()
            }
        }

        func decode<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
            guard let value = object[key.stringValue] else { fatalError() }
            decoder.stroage.append(value)
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
            ) throws -> Swift.KeyedDecodingContainer<NestedKey> {
            guard let value = object[key.stringValue] else { fatalError() }
            switch value {
            case .object(let object):
                return Swift.KeyedDecodingContainer(KeyedDecodingContainer<NestedKey>(codingPath: codingPath + [key],
                                                                                 decoder: decoder,
                                                                                 object: object))
            default:
                fatalError()
            }
        }

        func nestedUnkeyedContainer(forKey key: Key) throws -> Swift.UnkeyedDecodingContainer {
            guard let value = object[key.stringValue] else { fatalError() }
            switch value {
            case .array(let array):
                return UnkeyedDecodingContainer(codingPath: codingPath + [key], decoder: decoder, array: array)
            default:
                fatalError()
            }
        }

        func superDecoder() throws -> Swift.Decoder {
            return decoder
        }

        func superDecoder(forKey key: Key) throws -> Swift.Decoder {
            return decoder
        }
    }
}
