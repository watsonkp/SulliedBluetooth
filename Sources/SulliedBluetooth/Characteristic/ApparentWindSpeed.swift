import Foundation

// Apparent Wind Speed characteristic 0x2A72
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.apparent_wind_speed.yaml
public struct ApparentWindSpeed {
    let apparentWindSpeed: UInt16
    public init?(from value: Data) {
        guard let speed = ApparentWindSpeed.readUInt16(at: 0, of: value) else {
            return nil
        }
        apparentWindSpeed = speed
    }
}

extension ApparentWindSpeed : CustomStringConvertible {
    public var description: String {
        get {
            Measurement(value: Double(apparentWindSpeed) / 100.0,
                        unit: UnitSpeed.metersPerSecond)
            .formatted()
        }
    }
}

extension ApparentWindSpeed : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        get {
            ["Apparent Wind Speed" : String(describing: self)]
        }
    }
}
