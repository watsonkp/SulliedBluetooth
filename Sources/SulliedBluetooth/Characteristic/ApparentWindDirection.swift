import Foundation

// Apparent Wind Direction characteristic 0x2A73
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.apparent_wind_direction.yaml
public struct ApparentWindDirection {
    let apparentWindDirection: UInt16
    public init?(from value: Data) {
        guard let direction = ApparentWindDirection.readUInt16(at: 0, of: value),
              direction <= 35999 else {
            return nil
        }
        apparentWindDirection = direction
    }
}

extension ApparentWindDirection : CustomStringConvertible {
    public var description: String {
        get {
            Measurement(value: Double(apparentWindDirection) / 100.0, unit: UnitAngle.degrees).formatted()
        }
    }
}

extension ApparentWindDirection : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        get {
            ["Apparent Wind Direction" : String(describing: self)]
        }
    }
}
