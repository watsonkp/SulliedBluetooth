import Foundation
import CoreBluetooth

// A fallback implementation for unsupported characteristics
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/
public struct UnsupportedMeasurement: DecodedCharacteristic {
    public let uuid: CBUUID
    public let data: Data

    public init(forCharacteristic id: CBUUID, from value: Data) {
        uuid = id
        data = value
    }
}

extension UnsupportedMeasurement: CustomStringConvertible {
    public var description: String {
        get {
            return "\(uuid.uuidString) with \(data)"
        }
    }
}

extension UnsupportedMeasurement {
    public var fieldDescriptions: [String : String] {
        get {
            [
                "ID" : uuid.uuidString,
                "Length" : Measurement(value: Double(data.count),
                                       unit: UnitInformationStorage.bytes).formatted()
            ]
        }
    }
}
