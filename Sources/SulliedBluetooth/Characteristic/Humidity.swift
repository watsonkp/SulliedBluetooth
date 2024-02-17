import Foundation

// Humidity characteristic (0x2A6F)
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.humidity.yaml
// TODO: 0xFFFF represents an unknown value
public struct Humidity {
    let humidity: UInt16

    public init?(from value: Data) {
        guard let percentage = Humidity.readUInt16(at: 0, of: value),
              percentage <= 10000 else {
            return nil
        }
        humidity = percentage
    }
}

extension Humidity : CustomStringConvertible {
    public var description: String {
        get {
            "\(Double(humidity) / 100.0)%"
        }
    }
}

extension Humidity : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        ["Humidity" : String(describing: self)]
    }
}
