import Foundation

// Carbon Monoxide Concentration 0x2BD0
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.carbon_monoxide_concentration.yaml
public struct CarbonMonoxideConcentration {
    let carbonMonoxideConcentration: ShortDecimalFloat16

    public init?(from value: Data) {
        guard let concentration = CarbonMonoxideConcentration.readFloat16(at: 0, of: value) else {
            return nil
        }
        carbonMonoxideConcentration = concentration
    }
}

extension CarbonMonoxideConcentration : CustomStringConvertible {
    public var description: String {
        get {
            switch carbonMonoxideConcentration {
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

extension CarbonMonoxideConcentration : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        get {
            ["Carbon Monoxide Concentration": String(describing: self)]
        }
    }
}
