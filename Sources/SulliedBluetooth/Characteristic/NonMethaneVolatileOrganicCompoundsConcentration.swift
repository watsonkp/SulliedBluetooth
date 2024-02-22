import Foundation

// Non Methane Volatile Organic Compounds Concentration 0x2BD3
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.non-methane_volatile_organic_compounds_concentration.yaml
public struct NonMethaneVolatileOrganicCompoundsConcentration {
    let nonMethaneVolatileOrganicCompoundsConcentration: ShortDecimalFloat16

    public init?(from value: Data) {
        guard let concentration = NonMethaneVolatileOrganicCompoundsConcentration.readFloat16(at: 0, of: value) else {
            return nil
        }
        nonMethaneVolatileOrganicCompoundsConcentration = concentration
    }
}

extension NonMethaneVolatileOrganicCompoundsConcentration : CustomStringConvertible {
    public var description: String {
        get {
            switch nonMethaneVolatileOrganicCompoundsConcentration {
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

extension NonMethaneVolatileOrganicCompoundsConcentration : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        get {
            ["Non Methane Volatile Organic Compounds Concentration": String(describing: self)]
        }
    }
}
