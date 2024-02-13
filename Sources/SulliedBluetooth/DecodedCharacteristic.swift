import Foundation

protocol DecodedCharacteristic {
    // List of string descriptions for each field present in the characteristic.
    var fieldDescriptions: [String : String] { get }
}

extension DecodedCharacteristic {
    static func readInt16(at i: Int, of data: Data) -> Int16? {
        guard i + 1 < data.count else {
            return nil
        }
        return Int16(data[i]) | Int16(data[i+1])<<8
    }

    static func read2UInt12(at i: Int, of data: Data) -> (UInt16?, UInt16?) {
        guard i + 2 < data.count else {
            return (nil, nil)
        }
        return (UInt16(data[i]) | UInt16(data[i+1] & 0xf0)<<4, UInt16(data[i+1] & 0x0f) | UInt16(data[i+2])<<4)
    }

    static func readUInt8(at i: Int, of data: Data) -> UInt8? {
        guard i < data.count else {
            return nil
        }
        return UInt8(data[i])
    }

    static func readUInt16(at i: Int, of data: Data) -> UInt16? {
        guard i + 1 < data.count else {
            return nil
        }
        return UInt16(data[i]) | UInt16(data[i+1])<<8
    }

    static func readUInt32(at i: Int, of data: Data) -> UInt32? {
        guard i + 3 < data.count else {
            return nil
        }
        return UInt32(data[i]) | UInt32(data[i+1])<<8 | UInt32(data[i+2])<<16 | UInt32(data[i+3])<<24
    }

    static func readString(at i: Int, of data: Data) -> String {
        return String(unsafeUninitializedCapacity: data.count) {
            _ = $0.initialize(from: data)
            return data.count
        }
    }
}
