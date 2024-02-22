import Foundation

// Ozone Concentration characteristic 0x2BD4
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.ozone_concentration.yaml
public struct OzoneConcentration {
    let ozoneConcentration: ShortDecimalFloat16

    public init?(from value: Data) {
        guard let concentration = OzoneConcentration.readFloat16(at: 0, of: value) else {
            return nil
        }
        ozoneConcentration = concentration
    }
}

extension OzoneConcentration : CustomStringConvertible {
    public var description: String {
        get {
            switch ozoneConcentration {
            case .finite(let concentration):
                // kg/㎥ == g/L
                return Measurement(value: Double(truncating: concentration as NSNumber),
                                   unit: UnitConcentrationMass.gramsPerLiter)
                .formatted()
            case .NaN:
                return "Invalid"
            case .Nres:
                return "Outside of range"
            case .infinity:
                return "∞"
            case .negativeInfinity:
                return "-∞"
            case .reservedForFutureUse:
                return "Reserved for future use"
            }
        }
    }
}

extension OzoneConcentration : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        get {
            ["Ozone Concentration": String(describing: self)]
        }
    }
}
