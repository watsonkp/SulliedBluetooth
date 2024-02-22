import Foundation

// Rainfall characteristic 0x2A78
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.rainfall.yaml
public struct Rainfall {
    let rainfall: UInt16
    public init?(from value: Data) {
        guard let depth = Rainfall.readUInt16(at: 0, of: value) else {
            return nil
        }
        rainfall = depth
    }
}

extension Rainfall : CustomStringConvertible {
    public var description: String {
        get {
            Measurement(value: Double(rainfall),
                        unit: UnitLength.millimeters)
            .formatted()
        }
    }
}

extension Rainfall : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        get {
            ["Rainfall" : String(describing: self)]
        }
    }
}
