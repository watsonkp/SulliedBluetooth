import Foundation

// Sulfur Hexafluoride Concentration 0x2BD9
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.sulfur_hexafluoride_concentration.yaml
public struct SulfurHexafluorideConcentration {
    let sulfurHexafluorideConcentration: ShortDecimalFloat16

    public init?(from value: Data) {
        guard let concentration = SulfurHexafluorideConcentration.readFloat16(at: 0, of: value) else {
            return nil
        }
        sulfurHexafluorideConcentration = concentration
    }
}

extension SulfurHexafluorideConcentration : CustomStringConvertible {
    public var description: String {
        get {
            switch sulfurHexafluorideConcentration {
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

extension SulfurHexafluorideConcentration : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        get {
            ["Sulfur Hexafluoride Concentration": String(describing: self)]
        }
    }
}
