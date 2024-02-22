import Foundation

// Ammonia Concentration characteristic 0x2BCF
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.ammonia_concentration.yaml
public struct AmmoniaConcentration {
    let ammoniaConcentration: ShortDecimalFloat16

    public init?(from value: Data) {
        guard let concentration = AmmoniaConcentration.readFloat16(at: 0, of: value) else {
            return nil
        }
        ammoniaConcentration = concentration
    }
}

extension AmmoniaConcentration : CustomStringConvertible {
    public var description: String {
        get {
            switch ammoniaConcentration {
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

extension AmmoniaConcentration : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        get {
            ["Ammonia Concentration": String(describing: self)]
        }
    }
}
