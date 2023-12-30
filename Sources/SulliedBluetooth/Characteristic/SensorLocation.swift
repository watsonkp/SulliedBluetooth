import Foundation

// Sensor Location characteristic
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.sensor_location.yaml
public enum SensorLocation: UInt8 {
    case other = 0
    case topOfShoe = 1
    case inShoe = 2
    case hip = 3
    case frontWheel = 4
    case leftCrank = 5
    case rightCrank = 6
    case leftPedal = 7
    case rightPedal = 8
    case frontHub = 9
    case rearDropout = 10
    case chainstay = 11
    case rearWheel = 12
    case rearHub = 13
    case chest = 14
    case spider = 15
    case chainRing = 16
}

extension SensorLocation: CustomStringConvertible {
    public var description: String {
        get {
            switch self {
            case .other:
                return "Other"
            case .topOfShoe:
                return "Top of shoe"
            case .inShoe:
                return "In shoe"
            case .hip:
                return "Hip"
            case .frontWheel:
                return "Front wheel"
            case .leftCrank:
                return "Left crank"
            case .rightCrank:
                return "Right crank"
            case .leftPedal:
                return "Left pedal"
            case .rightPedal:
                return "Right pedal"
            case .frontHub:
                return "Front hub"
            case .rearDropout:
                return "Rear dropout"
            case .chainstay:
                return "Chainstay"
            case .rearWheel:
                return "Rear wheel"
            case .rearHub:
                return "Rear hub"
            case .chest:
                return "Chest"
            case .spider:
                return "Spider"
            case .chainRing:
                return "Chain ring"
            }
        }
    }
}
