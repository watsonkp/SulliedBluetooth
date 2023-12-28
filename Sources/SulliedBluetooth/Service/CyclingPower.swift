import Foundation

// Cycling Power Service 1.1
//  https://www.bluetooth.com/specifications/specs/cycling-power-service-1-1/

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

// Cycling Power Measurement characteristic
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.cycling_power_measurement.yaml
public struct CyclingPowerMeasurement: DecodedCharacteristic {
    let instantaneousPower: Int16
    // Unit is 0.5%
    let pedalPowerBalance: UInt8?
    let pedalPowerBalanceReference: PedalPowerBalanceReference
    // Unit is 1/32 Newton meter
    let accumulatedTorque: UInt16?
    let accumulatedTorqueSource: AccumulatedTorqueSource
    let cumulativeWheelRevolutions: UInt32?
    // Unit is 1/2048 second
    let wheelEventTime: UInt16?
    let cumulativeCrankRevolutions: UInt16?
    // Unit is 1/1024 second
    let crankEventTime: UInt16?
    let maximumForceMagnitude: Int16?
    let minimumForceMagnitude: Int16?
    // Unit is 1/32 Newton meter
    let maximumTorqueMagnitude: Int16?
    // Unit is 1/32 Newton meter
    let minimumTorqueMagnitude: Int16?
    let maximumAngle: UInt16?
    let minimumAngle: UInt16?
    let topDeadSpotAngle: UInt16?
    let bottomDeadSpotAngle: UInt16?
    // Unit is kilojoule
    let accumulatedEnergy: UInt16?
    let offsetCompensationIndicator: Bool

    enum PedalPowerBalanceReference {
        case unknown
        case left
    }

    enum AccumulatedTorqueSource {
        case wheel
        case crank
    }

    init?(value: Data) {
        // 16 bits of flags
        var i = 2
        guard let power = CyclingPowerMeasurement.readInt16(at: i, of: value) else {
            return nil
        }
        instantaneousPower = power
        i += 2

        if (value[0] & 0x01) != 0 {
            // Pedal power balance present
            pedalPowerBalance = value[i]
            i += 1
        } else {
            pedalPowerBalance = nil
        }

        // Pedal power balance reference
        pedalPowerBalanceReference = (value[0] & 0x02) != 0 ? .left : .unknown

        if (value[0] & 0x04) != 0 {
            // Accumulated torque present
            accumulatedTorque = CyclingPowerMeasurement.readUInt16(at: i, of: value)
            i += 2
        } else {
            accumulatedTorque = nil
        }

        // Accumulated torque source
        accumulatedTorqueSource = (value[0] & 0x08) != 0 ? .crank : .wheel

        if (value[0] & 0x10) != 0 {
            // Wheel revolution data present
            cumulativeWheelRevolutions = CyclingPowerMeasurement.readUInt32(at: i, of: value)
            i += 4
            wheelEventTime = CyclingPowerMeasurement.readUInt16(at: i, of: value)
            i += 2
        } else {
            cumulativeWheelRevolutions = nil
            wheelEventTime = nil
        }

        if (value[0] & 0x20) != 0 {
            // Crank revolution data present
            cumulativeCrankRevolutions = CyclingPowerMeasurement.readUInt16(at: i, of: value)
            i += 2
            crankEventTime = CyclingPowerMeasurement.readUInt16(at: i, of: value)
            i += 2
        } else {
            cumulativeCrankRevolutions = nil
            crankEventTime = nil
        }

        if (value[0] & 0x40) != 0 {
            // Extreme force magnitudes present
            maximumForceMagnitude = CyclingPowerMeasurement.readInt16(at: i, of: value)
            i += 2
            minimumForceMagnitude = CyclingPowerMeasurement.readInt16(at: i, of: value)
            i += 2
        } else {
            maximumForceMagnitude = nil
            minimumForceMagnitude = nil
        }

        if (value[0] & 0x80) != 0 {
            // Extreme torque magnitudes present
            maximumTorqueMagnitude = CyclingPowerMeasurement.readInt16(at: i, of: value)
            i += 2
            minimumTorqueMagnitude = CyclingPowerMeasurement.readInt16(at: i, of: value)
            i += 2
        } else {
            maximumTorqueMagnitude = nil
            minimumTorqueMagnitude = nil
        }
        if (value[1] & 0x01) != 0 {
            // Extreme angles present
            (maximumAngle, minimumAngle) = CyclingPowerMeasurement.read2UInt12(at: i, of: value)
            i += 3
        } else {
            maximumAngle = nil
            minimumAngle = nil
        }

        if (value[1] & 0x02) != 0 {
            // Top dead spot angle present
            topDeadSpotAngle = CyclingPowerMeasurement.readUInt16(at: i, of: value)
            i += 2
        } else {
            topDeadSpotAngle = nil
        }

        if (value[1] & 0x04) != 0 {
            // Bottom dead spot angle present
            bottomDeadSpotAngle = CyclingPowerMeasurement.readUInt16(at: i, of: value)
            i += 2
        } else {
            bottomDeadSpotAngle = nil
        }

        if (value[1] & 0x08) != 0 {
            // Accumulated energy present
            accumulatedEnergy = CyclingPowerMeasurement.readUInt16(at: i, of: value)
            i += 2
        } else {
            accumulatedEnergy = nil
        }

        // Offset compensation indicator
        offsetCompensationIndicator = (value[1] & 0x10) != 0
    }
}

extension CyclingPowerMeasurement: CustomStringConvertible {
    public var description: String {
        get {
            return Measurement(value: Double(instantaneousPower), unit: UnitPower.watts).formatted()
        }
    }
}

protocol DecodedCharacteristic {
    // TODO: List of string descriptions for each field present in the characteristic.
//    var fieldDescriptions: [String] { get }
}

extension DecodedCharacteristic {
    static func readInt16(at i: Int, of data: Data) -> Int16? {
        guard i + 1 < data.count else {
            return nil
        }
        return Int16(data[i])<<8 | Int16(data[i+1])
    }

    static func read2UInt12(at i: Int, of data: Data) -> (UInt16?, UInt16?) {
        guard i + 2 < data.count else {
            return (nil, nil)
        }
        return (UInt16(data[i])<<4 | UInt16(data[i+1] & 0xf0)>>4, UInt16(data[i+1] & 0x0f)<<8 | UInt16(data[i+2]))
    }

    static func readUInt16(at i: Int, of data: Data) -> UInt16? {
        guard i + 1 < data.count else {
            return nil
        }
        return UInt16(data[i])<<8 | UInt16(data[i+1])
    }

    static func readUInt32(at i: Int, of data: Data) -> UInt32? {
        guard i + 3 < data.count else {
            return nil
        }
        return UInt32(data[i])<<24 | UInt32(data[i+1])<<16 | UInt32(data[i+2])<<8 | UInt32(data[i+3])
    }
}
