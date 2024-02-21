import Foundation

// Barometric Pressure Trend characteristic 0x2AA3
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.barometric_pressure_trend.yaml
// TODO: Design and implement recording of this value.
public struct BarometricPressureTrend {
    let barometricPressureTrend: UInt8
    public init?(from value: Data) {
        guard let trend = BarometricPressureTrend.readUInt8(at: 0, of: value) else {
            return nil
        }
        barometricPressureTrend = trend
    }
}

extension BarometricPressureTrend : CustomStringConvertible {
    public var description: String {
        get {
            switch barometricPressureTrend {
            case 0x0:
                return "Unknown"
            case 0x1:
                return "Continuously falling"
            case 0x2:
                return "Continuously rising"
            case 0x3:
                return "Falling, then steady"
            case 0x4:
                return "Rising, then steady"
            case 0x5:
                return "Falling before a lesser rise"
            case 0x6:
                return "Falling before a greater rise"
            case 0x7:
                return "Rising before a greater fall"
            case 0x8:
                return "Rising before a lesser fall"
            case 0x9:
                return "Steady"
            default:
                return "Reserved for Future Use"
            }
        }
    }
}

extension BarometricPressureTrend : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        get {
            ["Barometric Pressure Trend": String(describing: self)]
        }
    }
}
