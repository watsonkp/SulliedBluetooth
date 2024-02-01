import Foundation

// Cycling Speed and Cadence Service 1.0
//  https://www.bluetooth.com/specifications/specs/cycling-speed-and-cadence-service-1-0/

// CSCMeasurement characteristic
public struct CSCMeasurement: CustomStringConvertible, DecodedCharacteristic {
    public let cumulativeWheelRevolutions: UInt32?
    // Unit is 1/1024 of a seecond
    public let wheelEventTime: UInt16?
    public let cumulativeCrankRevolutions: UInt16?
    // Unit is 1/1024 of a second
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

    public init(value: Data) {
        var index = 1

        if (value[0] & 0x1) != 0 {
            cumulativeWheelRevolutions = CSCMeasurement.readUInt32(at: index, of: value)
            index += 4
            wheelEventTime = CSCMeasurement.readUInt16(at: index, of: value)
            index += 2
        } else {
            cumulativeWheelRevolutions = nil
            wheelEventTime = nil
        }

        if (value[0] & 0x2) != 0 {
            cumulativeCrankRevolutions = CSCMeasurement.readUInt16(at: index, of: value)
            index += 2
            crankEventTime = CSCMeasurement.readUInt16(at: index, of: value)
            index += 2
        } else {
            cumulativeCrankRevolutions = nil
            crankEventTime = nil
        }
    }
}
