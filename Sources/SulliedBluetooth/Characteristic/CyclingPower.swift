import Foundation

// Cycling Power Service 1.1
//  https://www.bluetooth.com/specifications/specs/cycling-power-service-1-1/

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

    private static let durationStyle = Measurement<UnitDuration>.FormatStyle(width: .wide, numberFormatStyle: .number.precision(.significantDigits(1..<5)))

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
            let power = Measurement(value: Double(instantaneousPower), unit: UnitPower.watts).formatted()
            if let cumulativeWheelRevolutions = cumulativeWheelRevolutions,
               let wheelEventTime = wheelEventTime,
               let cumulativeCrankRevolutions = cumulativeCrankRevolutions,
               let crankEventTime = crankEventTime {
                return "\(power) Wheel(\(cumulativeWheelRevolutions), \(CyclingPowerMeasurement.durationStyle.format(Measurement(value: Double(wheelEventTime) / 2048, unit: UnitDuration.seconds))), Crank(\(cumulativeCrankRevolutions), \(CyclingPowerMeasurement.durationStyle.format(Measurement(value: Double(crankEventTime) / 1024, unit: UnitDuration.seconds)))"
            } else if let cumulativeWheelRevolutions = cumulativeWheelRevolutions,
                      let wheelEventTime = wheelEventTime {
                return "\(power) Wheel(\(cumulativeWheelRevolutions), \(CyclingPowerMeasurement.durationStyle.format(Measurement(value: Double(wheelEventTime) / 2048, unit: UnitDuration.seconds)))"
            } else if let cumulativeCrankRevolutions = cumulativeCrankRevolutions,
                      let crankEventTime = crankEventTime {
                return "\(power) Crank(\(cumulativeCrankRevolutions), \(CyclingPowerMeasurement.durationStyle.format(Measurement(value: Double(crankEventTime) / 1024, unit: UnitDuration.seconds))))"
            } else {
                return power
            }
        }
    }
}
