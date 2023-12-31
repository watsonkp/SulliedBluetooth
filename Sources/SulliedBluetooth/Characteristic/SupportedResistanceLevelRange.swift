import Foundation

// Supported Resistance Level Range characteristic 0x2AD6
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.supported_resistance_level_range.yaml
public struct SupportedResistanceLevelRange: DecodedCharacteristic {
    let minimumResistanceLevel: UInt8
    let maximumResistanceLevel: UInt8
    let minimumIncrement: UInt8

    init?(value: Data) {
        guard value.count == 3 else {
            return nil
        }

        minimumResistanceLevel = value[0]
        maximumResistanceLevel = value[1]
        minimumIncrement = value[2]
    }
}

extension SupportedResistanceLevelRange: CustomStringConvertible {
    public var description: String {
        get {
            "\(minimumResistanceLevel) - \(maximumResistanceLevel) by \(minimumIncrement)"
        }
    }
}
