import Foundation

protocol DecodedCharacteristic {
    // List of string descriptions for each field present in the characteristic.
    var fieldDescriptions: [String : String] { get }
}

extension DecodedCharacteristic {
    static func readInt8(at i: Int, of data: Data) -> Int8? {
        guard i < data.count else {
            return nil
        }
        return Int8(data[i])
    }

    static func readInt16(at i: Int, of data: Data) -> Int16? {
        guard i + 1 < data.count else {
            return nil
        }
        return Int16(data[i]) | Int16(data[i+1])<<8
    }

    static func readInt24(at i: Int, of data: Data) -> Int32? {
        guard i + 2 < data.count else {
            return nil
        }
        return Int32(bitPattern: UInt32(data[i])) | Int32(bitPattern: UInt32(data[i+1])<<8) | Int32(Int8(bitPattern: data[i+2]))<<16
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

    static func readUInt24(at i: Int, of data: Data) -> UInt32? {
        guard i + 2 < data.count else {
            return nil
        }
        return UInt32(data[i]) | UInt32(data[i+1])<<8 | UInt32(data[i+2])<<16
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

    // IEEE 11073-20601 16-bit SFLOAT
    // 4 bit signed exponent, 12 bit signed mantissa, base 10, twos complement
    // mantissa * 10^exponent
    // The return type is an enum that uses Decimal to more closely match the base 10 floating point implementation.
    static func readFloat16(at i: Int, of data: Data) -> ShortDecimalFloat16? {
        // Check that 2 bytes are available
        guard i + 1 < data.count else {
            return nil
        }

        // NaN
        guard !(data[0] == 0x07 && data[1] == 0xff) else {
            return .NaN
        }
        // Infinity
        guard !(data[0] == 0x07 && data[1] == 0xfe) else {
            return .infinity
        }
        // Negative infinity
        guard !(data[0] == 0x08 && data[1] == 0x02) else {
            return .negativeInfinity
        }
        // Nres
        guard !(data[0] == 0x08 && data[1] == 0x00) else {
            return .Nres
        }
        // Reserved for future use
        guard !(data[0] == 0x08 && data[1] == 0x01) else {
            return nil
        }

        // 4 bit signed exponent
        let exponent = Int8(bitPattern: data[0] & 0xF0) >> 4

        // 12 bit signed mantissa in twos complement
        let mantissaSign: FloatingPointSign = data[0] & 0x08 == 0 ? .plus : .minus
        let mantissa = Int16(Int8(bitPattern: mantissaSign == .plus ? data[0] & 0x0F : 0xF0 | data[0])) << 8 | Int16(bitPattern: UInt16(data[1]))

        // Base 10
        return .finite(Decimal(sign: mantissaSign, exponent: Int(exponent), significand: Decimal(mantissa)))
    }
}
