import Foundation

public enum BodySensorLocation: UInt8 {
    case other = 0x00
    case chest = 0x01
    case wrist = 0x02
    case finger = 0x03
    case hand = 0x04
    case earLobe = 0x05
    case foot = 0x06
}

extension BodySensorLocation: CustomStringConvertible {
    public var description: String {
        get {
            switch self {
            case .other:
                return "Other"
            case .chest:
                return "Chest"
            case .wrist:
                return "Wrist"
            case .finger:
                return "Finger"
            case .hand:
                return "Hand"
            case .earLobe:
                return "Ear Lobe"
            case .foot:
                return "Foot"
            }
        }
    }
}
