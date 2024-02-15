import Foundation

// CO₂ Concentration characteristic (0x2B8C)
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.co2_concentration.yaml
public struct CO2Concentration {
    let co2Concentration: UInt16

    public init?(from value: Data) {
        guard let concentration = CO2Concentration.readUInt16(at: 0, of: value) else {
            return nil
        }
        co2Concentration = concentration
    }
}

extension CO2Concentration : CustomStringConvertible {
    public var description: String {
        get {
            Measurement(value: Double(co2Concentration),
                        unit: UnitDispersion.partsPerMillion).formatted() + " CO₂"
        }
    }
}

extension CO2Concentration : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        get {
            [
                "CO₂ Concentration" : Measurement(value: Double(co2Concentration),
                                                  unit: UnitDispersion.partsPerMillion).formatted()
            ]
        }
    }
}
