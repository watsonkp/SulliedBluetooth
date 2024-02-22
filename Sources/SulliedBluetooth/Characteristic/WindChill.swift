import Foundation

// Wind Chill characteristic 0x2A79
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.wind_chill.yaml
public struct WindChill {
    let windChill: Int8

    public init?(from value: Data) {
        guard let temperature = WindChill.readInt8(at: 0, of: value) else {
            return nil
        }
        windChill = temperature
    }
}

extension WindChill : CustomStringConvertible {
    public var description: String {
        get {
            Measurement(value: Double(windChill),
                        unit: UnitTemperature.celsius)
            .formatted()
        }
    }
}

extension WindChill : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        get {
            ["Wind Chill": String(describing: self)]
        }
    }
}
