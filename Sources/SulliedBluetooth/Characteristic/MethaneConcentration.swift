import Foundation

// Methane Concentration characteristic 0x2BD1
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.methane_concentration.yaml
public struct MethaneConcentration {
    let methaneConcentration: ShortDecimalFloat16

    public init?(from value: Data) {
        guard let concentration = MethaneConcentration.readFloat16(at: 0, of: value) else {
            return nil
        }
        methaneConcentration = concentration
    }
}

extension MethaneConcentration : CustomStringConvertible {
    public var description: String {
        get {
            switch methaneConcentration {
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

extension MethaneConcentration : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        get {
            ["Methane Concentration": String(describing: self)]
        }
    }
}
