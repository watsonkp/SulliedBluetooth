import Foundation

// Heart Rate Measurement characteristic
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.heart_rate_measurement.yaml
public struct HeartRateMeasurement: DecodedCharacteristic {
    public let heartRateMeasurementValue: UInt16
    public let sensorContactSupported: Bool
    public let sensorContactDetected: Bool
    public let energyExpended: UInt16?
    public let rrInterval: [UInt16]?

    private static let formatter = {
        let f = MeasurementFormatter()
        f.unitOptions = .providedUnit
        return f
    }()

    public init?(value: Data) {
        // 8 bits of flags
        var i = 1

        // Parse 8 or 16 bit heart rate measurement
        if (value[0] & 0x01) != 0 {
            guard let heartRate = HeartRateMeasurement.readUInt16(at: i, of: value) else {
                return nil
            }
            heartRateMeasurementValue = heartRate
            i += 2
        } else {
            guard let heartRate = HeartRateMeasurement.readUInt8(at: i, of: value) else {
                return nil
            }
            heartRateMeasurementValue = UInt16(heartRate)
            i += 1
        }

        // Parse sensor contact support and detection
        if (value[0] & 0x6) == 0x6 {
            // Sensor Contact feature is supported and contact is detected
            sensorContactSupported = true
            sensorContactDetected = true
        } else if (value[0] & 0x6) == 0x4 {
            // Sensor Contact feature is supported, but contact is not detected
            sensorContactSupported = true
            sensorContactDetected = false
        } else {
            sensorContactSupported = false
            sensorContactDetected = false
        }

        // Parse optional energy expended field
        // WARNING: The value is cumulative and will get stuck at a peak of 0xFFFF or 65535 kilojoules or 15663 calories.
        // TODO: Reset counter when it caps at 0xFFFF.
        if (value[0] & 0x8) != 0 {
            guard let energy = HeartRateMeasurement.readUInt16(at: i, of: value) else {
                return nil
            }
            energyExpended = energy
            i += 2
        } else {
            energyExpended = nil
        }

        // Parse optional RR-interval field
        rrInterval = stride(from: i, to: value.count, by: 2).compactMap {
            guard i + 1 < value.count else {
                return nil
            }
            return HeartRateMeasurement.readUInt16(at: $0, of: value)
        }
    }
}

extension HeartRateMeasurement: CustomStringConvertible {
    public var description: String {
        get {
            return HeartRateMeasurement.formatter.string(from: Measurement(value: Double(heartRateMeasurementValue),
                                                                           unit: UnitFrequency.beatsPerMinute))
        }
    }
}

extension HeartRateMeasurement {
    public var fieldDescriptions: [String : String] {
        get {
            var fields = ["Heart Rate" : HeartRateMeasurement.formatter.string(from: Measurement<UnitFrequency>(value: Double(heartRateMeasurementValue),
                                                                                                 unit: UnitFrequency.beatsPerMinute))]

            if let energyExpended = energyExpended {
                fields["Energy Expended"] = Measurement<UnitEnergy>(value: Double(energyExpended),
                                                                    unit: UnitEnergy.kilojoules)
                .formatted(.measurement(width: .wide, usage: .workout))
            }

            if let rrInterval = rrInterval {
                fields["RR-Intervals"] = rrInterval.map { Measurement(value: Double($0), unit: UnitDuration.milliseconds).formatted() }
                    .joined(separator: ", ")
            }

            return fields
        }
    }
}
