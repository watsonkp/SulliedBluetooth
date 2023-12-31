import Foundation

public struct SupportedPowerRange: DecodedCharacteristic {
    let minimumPower: Int16
    let maximumPower: Int16
    let increment: UInt16

    public init?(value: Data) {
        guard let min = SupportedPowerRange.readInt16(at: 0, of: value),
              let max = SupportedPowerRange.readInt16(at: 2, of: value),
              let inc = SupportedPowerRange.readUInt16(at: 2, of: value) else {
            return nil
        }
        minimumPower = min
        maximumPower = max
        increment = inc
    }
}

extension SupportedPowerRange: CustomStringConvertible {
    public var description: String {
        get {
            "\(Measurement(value: Double(minimumPower), unit: UnitPower.watts)) - \(Measurement(value: Double(maximumPower), unit: UnitPower.watts)) by \(Measurement(value: Double(increment), unit: UnitPower.watts))"
        }
    }
}
