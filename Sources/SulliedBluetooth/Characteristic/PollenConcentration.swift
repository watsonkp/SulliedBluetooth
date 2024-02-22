import Foundation

// Pollen Concentration characteristic 0x2A75
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.pollen_concentration.yaml
public struct PollenConcentration {
    let pollenConcentration: UInt32
    public init?(from value: Data) {
        guard let concentration = PollenConcentration.readUInt24(at: 0, of: value) else {
            return nil
        }
        pollenConcentration = concentration
    }
}

extension PollenConcentration : CustomStringConvertible {
    public var description: String {
        get {
            "\(pollenConcentration) /㎥"
        }
    }
}

extension PollenConcentration : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        get {
            ["Pollen Concentration" : String(describing: self)]
        }
    }
}
