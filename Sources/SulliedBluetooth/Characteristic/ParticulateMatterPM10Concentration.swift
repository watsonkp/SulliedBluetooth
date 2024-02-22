import Foundation

// Particulate Matter PM10 Concentration characteristic 0x2BD7
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.particulate_matter_-_pm10_concentration.yaml
public struct ParticulateMatterPM10Concentration {
    let particulateMatterPM10Concentration: ShortDecimalFloat16

    public init?(from value: Data) {
        guard let concentration = ParticulateMatterPM10Concentration.readFloat16(at: 0, of: value) else {
            return nil
        }
        particulateMatterPM10Concentration = concentration
    }
}

extension ParticulateMatterPM10Concentration : CustomStringConvertible {
    public var description: String {
        get {
            switch particulateMatterPM10Concentration {
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

extension ParticulateMatterPM10Concentration : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        get {
            ["Particulate Matter PM10 Concentration": String(describing: self)]
        }
    }
}
