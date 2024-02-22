import Foundation

// True Wind Direction characteristic 0x2A71
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.true_wind_direction.yaml
public struct TrueWindDirection {
    let trueWindDirection: UInt16

    public init?(from value: Data) {
        guard let angle = TrueWindDirection.readUInt16(at: 0, of: value) else {
            return nil
        }
        trueWindDirection = angle
    }
}

extension TrueWindDirection : CustomStringConvertible {
    public var description: String {
        get {
            Measurement(value: Double(trueWindDirection) / 100.0,
                        unit: UnitAngle.degrees)
            .formatted()
        }
    }
}

extension TrueWindDirection : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        get {
            ["True Wind Direction": String(describing: self)]
        }
    }
}
