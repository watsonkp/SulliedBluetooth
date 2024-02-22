import Foundation

// Particulate Matter PM2.5 Concentration characteristic 0x2BD6
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.particulate_matter_-_pm2.5_concentration.yaml
public struct ParticulateMatterPM25Concentration {
    let particulateMatterPM25Concentration: ShortDecimalFloat16

    public init?(from value: Data) {
        guard let concentration = ParticulateMatterPM25Concentration.readFloat16(at: 0, of: value) else {
            return nil
        }
        particulateMatterPM25Concentration = concentration
    }
}

extension ParticulateMatterPM25Concentration : CustomStringConvertible {
    public var description: String {
        get {
            switch particulateMatterPM25Concentration {
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

extension ParticulateMatterPM25Concentration : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        get {
            ["Particulate Matter PM2.5 Concentration": String(describing: self)]
        }
    }
}
