import Foundation

// Sulfur Dioxide Concentration characteristic 0x2BD8
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.sulfur_dioxide_concentration.yaml
public struct SulfurDioxideConcentration {
    let sulfurDioxideConcentration: ShortDecimalFloat16

    public init?(from value: Data) {
        guard let concentration = SulfurDioxideConcentration.readFloat16(at: 0, of: value) else {
            return nil
        }
        sulfurDioxideConcentration = concentration
    }
}

extension SulfurDioxideConcentration : CustomStringConvertible {
    public var description: String {
        get {
            switch sulfurDioxideConcentration {
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

extension SulfurDioxideConcentration : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        get {
            ["Sulfur Dioxide Concentration": String(describing: self)]
        }
    }
}
