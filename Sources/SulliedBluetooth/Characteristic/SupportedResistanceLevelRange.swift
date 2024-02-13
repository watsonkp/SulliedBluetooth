import Foundation

// Supported Resistance Level Range characteristic 0x2AD6
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.supported_resistance_level_range.yaml
//  Specification lists 3 UInt8, but in practice 3 UInt16 can be used.
public struct SupportedResistanceLevelRange: DecodedCharacteristic {
    let minimumResistanceLevel: Int16
    let maximumResistanceLevel: Int16
    let minimumIncrement: UInt16

    init?(value: Data) {
        if value.count == 3 {
            minimumResistanceLevel = Int16(value[0])
            maximumResistanceLevel = Int16(value[1])
            minimumIncrement = UInt16(value[2])
        } else if value.count == 6 {
            guard let min = SupportedResistanceLevelRange.readInt16(at: 0, of: value),
                  let max = SupportedResistanceLevelRange.readInt16(at: 2, of: value),
                  let inc = SupportedResistanceLevelRange.readUInt16(at: 4, of: value) else {
                return nil
            }
            minimumResistanceLevel = min
            maximumResistanceLevel = max
            minimumIncrement = inc
        } else {
            return nil
        }
    }
}

extension SupportedResistanceLevelRange: CustomStringConvertible {
    public var description: String {
        get {
            "\(minimumResistanceLevel) - \(maximumResistanceLevel) by \(minimumIncrement)"
        }
    }
}

extension SupportedResistanceLevelRange {
    public var fieldDescriptions: [String : String] {
        get {
            [
                "Minimum" : "\(minimumResistanceLevel)",
                "Maximum" : "\(maximumResistanceLevel)",
                "Increment" : "\(minimumIncrement)"
            ]
        }
    }
}
