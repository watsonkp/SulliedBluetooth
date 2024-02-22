import Foundation

// True Wind Direction characteristic 0x2A70
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.true_wind_speed.yaml
public struct TrueWindSpeed {
    let trueWindSpeed: UInt16

    public init?(from value: Data) {
        guard let speed = TrueWindSpeed.readUInt16(at: 0, of: value) else {
            return nil
        }
        trueWindSpeed = speed
    }
}

extension TrueWindSpeed : CustomStringConvertible {
    public var description: String {
        get {
            Measurement(value: Double(trueWindSpeed) / 100.0,
                        unit: UnitSpeed.metersPerSecond)
            .formatted()
        }
    }
}

extension TrueWindSpeed : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        get {
            ["True Wind Speed": String(describing: self)]
        }
    }
}
