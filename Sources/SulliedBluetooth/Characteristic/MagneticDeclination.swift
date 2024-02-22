import Foundation

// Magnetic Declination characteristic 0x2A2C
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.magnetic_declination.yaml
public struct MagneticDeclination {
    let magneticDeclination: UInt16
    public init?(from value: Data) {
        guard let angle = MagneticDeclination.readUInt16(at: 0, of: value),
              angle < 35999 else {
            return nil
        }
        magneticDeclination = angle
    }
}

extension MagneticDeclination : CustomStringConvertible {
    public var description: String {
        get {
            Measurement(value: Double(magneticDeclination) / 100.0,
                        unit: UnitAngle.degrees)
            .formatted()
        }
    }
}

extension MagneticDeclination : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        get {
            ["Magnetic Declination" : String(describing: self)]
        }
    }
}
