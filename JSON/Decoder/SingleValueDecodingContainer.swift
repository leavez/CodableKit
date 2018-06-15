//
//  SingleValueDecodingContainer.swift
//  JSON
//
//  Created by 李孛 on 2018/6/15.
//

struct _SingleValueDecodingContainer: SingleValueDecodingContainer {
    let codingPath: [CodingKey]
    let decoder: _Decoder
    let value: JSON

    func decodeNil() -> Bool {
        switch value {
        case .null:
            return true
        default:
            return false
        }
    }

    func decode(_ type: Bool.Type) throws -> Bool {
        switch value {
        case .true:
            return true
        case .false:
            return false
        default:
            fatalError()
        }
    }

    func decode(_ type: Int.Type) throws -> Int {
        switch value {
        case .number(let number):
            guard let number = number as? Int else {
                fatalError()
            }
            return number
        default:
            fatalError()
        }
    }

    func decode(_ type: Int8.Type) throws -> Int8 {
        switch value {
        case .number(let number):
            guard let number = number as? Int8 else {
                fatalError()
            }
            return number
        default:
            fatalError()
        }
    }

    func decode(_ type: Int16.Type) throws -> Int16 {
        switch value {
        case .number(let number):
            guard let number = number as? Int16 else {
                fatalError()
            }
            return number
        default:
            fatalError()
        }
    }

    func decode(_ type: Int32.Type) throws -> Int32 {
        switch value {
        case .number(let number):
            guard let number = number as? Int32 else {
                fatalError()
            }
            return number
        default:
            fatalError()
        }
    }

    func decode(_ type: Int64.Type) throws -> Int64 {
        switch value {
        case .number(let number):
            guard let number = number as? Int64 else {
                fatalError()
            }
            return number
        default:
            fatalError()
        }
    }

    func decode(_ type: UInt.Type) throws -> UInt {
        switch value {
        case .number(let number):
            guard let number = number as? UInt else {
                fatalError()
            }
            return number
        default:
            fatalError()
        }
    }

    func decode(_ type: UInt8.Type) throws -> UInt8 {
        switch value {
        case .number(let number):
            guard let number = number as? UInt8 else {
                fatalError()
            }
            return number
        default:
            fatalError()
        }
    }

    func decode(_ type: UInt16.Type) throws -> UInt16 {
        switch value {
        case .number(let number):
            guard let number = number as? UInt16 else {
                fatalError()
            }
            return number
        default:
            fatalError()
        }
    }

    func decode(_ type: UInt32.Type) throws -> UInt32 {
        switch value {
        case .number(let number):
            guard let number = number as? UInt32 else {
                fatalError()
            }
            return number
        default:
            fatalError()
        }
    }

    func decode(_ type: UInt64.Type) throws -> UInt64 {
        switch value {
        case .number(let number):
            guard let number = number as? UInt64 else {
                fatalError()
            }
            return number
        default:
            fatalError()
        }
    }

    func decode(_ type: Float.Type) throws -> Float {
        switch value {
        case .number(let number):
            guard let number = number as? Float else {
                fatalError()
            }
            return number
        default:
            fatalError()
        }
    }

    func decode(_ type: Double.Type) throws -> Double {
        switch value {
        case .number(let number):
            guard let number = number as? Double else {
                fatalError()
            }
            return number
        default:
            fatalError()
        }
    }

    func decode(_ type: String.Type) throws -> String {
        switch value {
        case .string(let string):
            return string
        default:
            fatalError()
        }
    }

    func decode<T: Decodable>(_ type: T.Type) throws -> T {
        decoder.stroage.append(value)
        defer { decoder.stroage.removeLast() }
        return try T.init(from: decoder)
    }
}
