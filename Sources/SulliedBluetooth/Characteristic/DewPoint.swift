import Foundation

// Dew Point characteristic 0x2A7B
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.dew_point.yaml
public struct DewPoint {
    let dewPoint: Int8
    public init?(from value: Data) {
        guard let temperature = DewPoint.readInt8(at: 0, of: value) else {
            return nil
        }
        dewPoint = temperature
    }
}

extension DewPoint : CustomStringConvertible {
    public var description: String {
        get {
            Measurement(value: Double(dewPoint),
                        unit: UnitTemperature.celsius)
            .formatted()
        }
    }
}

extension DewPoint : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        get {
            ["Dew Point" : String(describing: self)]
        }
    }
}
