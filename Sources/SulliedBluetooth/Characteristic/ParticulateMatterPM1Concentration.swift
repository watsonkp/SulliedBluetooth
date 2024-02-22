import Foundation

// Particulate Matter PM1 Concentration characteristic 0x2BD5
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.particulate_matter_-_pm1_concentration.yaml
public struct ParticulateMatterPM1Concentration {
    let particulateMatterPM1Concentration: ShortDecimalFloat16

    public init?(from value: Data) {
        guard let concentration = ParticulateMatterPM1Concentration.readFloat16(at: 0, of: value) else {
            return nil
        }
        particulateMatterPM1Concentration = concentration
    }
}

extension ParticulateMatterPM1Concentration : CustomStringConvertible {
    public var description: String {
        get {
            switch particulateMatterPM1Concentration {
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

extension ParticulateMatterPM1Concentration : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        get {
            ["Particulate Matter PM1 Concentration": String(describing: self)]
        }
    }
}
