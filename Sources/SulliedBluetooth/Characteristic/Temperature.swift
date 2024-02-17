import Foundation

// Temperature characteristic (0x2A6E)
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.temperature.yaml
// TODO: 0x8000 represents an unknown value
public struct Temperature {
    let temperature: Int16

    public init?(from value: Data) {
        // Range is -273.15 to 327.67 degrees Celsius with a resolution of 0.01
        guard let t = Temperature.readInt16(at: 0, of: value),
              t <= 32767,
              t >= -27315 else {
            return nil
        }
        temperature = t
    }
}

extension Temperature: CustomStringConvertible {
    public var description: String {
        get {
            Measurement(value: Double(temperature) / 100.0,
                        unit: UnitTemperature.celsius).formatted()
        }
    }
}

extension Temperature : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        get {
            ["Temperature" : Measurement(value: Double(temperature) / 100.0,
                                         unit: UnitTemperature.celsius).formatted()]
        }
    }
}
