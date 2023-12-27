import Foundation

// CSCMeasurement characteristic
public struct CSCMeasurement: CustomStringConvertible {
    public let cumulativeWheelRevolutions: UInt32?
    public let wheelEventTime: UInt16?
    public let cumulativeCrankRevolutions: UInt16?
    public let crankEventTime: UInt16?

    public var description: String {
        get {
            if let cumulativeWheelRevolutions = cumulativeWheelRevolutions,
               let wheelEventTime = wheelEventTime,
               let cumulativeCrankRevolutions = cumulativeCrankRevolutions,
               let crankEventTime = crankEventTime {
                return "Wheel(\(cumulativeWheelRevolutions), \(wheelEventTime)), Crank(\(cumulativeCrankRevolutions), \(crankEventTime))"
            } else if let cumulativeWheelRevolutions = cumulativeWheelRevolutions,
                      let wheelEventTime = wheelEventTime {
                return "Wheel(\(cumulativeWheelRevolutions), \(wheelEventTime))"
            } else if let cumulativeCrankRevolutions = cumulativeCrankRevolutions,
                      let crankEventTime = crankEventTime {
                return "Crank(\(cumulativeCrankRevolutions), \(crankEventTime))"
            } else {
                return "--"
            }
        }
    }
}
