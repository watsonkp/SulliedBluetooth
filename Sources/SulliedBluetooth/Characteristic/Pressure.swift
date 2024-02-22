import Foundation

// Pressure characteristic 0x2A6D
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.pressure.yaml
public struct Pressure {
    let pressure: UInt32
    public init?(from value: Data) {
        guard let p = Pressure.readUInt32(at: 0, of: value) else {
            return nil
        }
        pressure = p
    }
}

extension Pressure : CustomStringConvertible {
    public var description: String {
        get {
            Measurement(value: Double(pressure) / 10.0,
                        unit: UnitPressure.newtonsPerMetersSquared)
            .formatted()
        }
    }
}

extension Pressure : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        get {
            ["Pressure" : String(describing: self)]
        }
    }
}
