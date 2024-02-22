import Foundation

// Nitrogen Dioxide Concentration characteristic 0x2BD2
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.nitrogen_dioxide_concentration.yaml
public struct NitrogenDioxideConcentration {
    let nitrogenDioxideConcentration: ShortDecimalFloat16

    public init?(from value: Data) {
        guard let concentration = NitrogenDioxideConcentration.readFloat16(at: 0, of: value) else {
            return nil
        }
        nitrogenDioxideConcentration = concentration
    }
}

extension NitrogenDioxideConcentration : CustomStringConvertible {
    public var description: String {
        get {
            switch nitrogenDioxideConcentration {
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

extension NitrogenDioxideConcentration : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        get {
            ["Nitrogen Dioxide Concentration": String(describing: self)]
        }
    }
}
