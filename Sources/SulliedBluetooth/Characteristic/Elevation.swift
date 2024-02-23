import Foundation

// Elevation characteristic 0x2A6C
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.elevation.yaml
public struct Elevation {
    // 0.01 m resolution
    let elevation: Int32

    public init?(from value: Data) {
        guard let d = Rainfall.readInt24(at: 0, of: value) else {
            return nil
        }
        elevation = d
    }
}

extension Elevation : CustomStringConvertible {
    public var description: String {
        get {
            Measurement(value: Double(elevation) / 100.0,
                        unit: UnitLength.meters)
            .formatted()
        }
    }
}

extension Elevation : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        get {
            ["Elevation": String(describing: self)]
        }
    }
}
