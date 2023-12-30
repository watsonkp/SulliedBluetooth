import Foundation

public struct Bluetooth {
    public static func decodeHeartRateMeasurement(value: Data) -> HeartRateMeasurement {
        // https://www.bluetooth.com/specifications/specs/heart-rate-service-1-0/
        var typedValue = [UInt8](repeating:0, count: 0xf)
        typedValue.withUnsafeMutableBytes({(bs: UnsafeMutableRawBufferPointer) -> Void in
            value.copyBytes(to: bs, count: value.count)
        })

        // TODO: Could OptionSet be helpful with this mess?
        var heartRate: UInt16 = 0
        if (value[0] & 0x1) != 0 {
            // Heart Rate Value Format is set to UINT16
            heartRate = UInt16((value[1]<<8) | value[2])
        } else {
            // Heart Rate Value Format is set to UINT8
            heartRate = UInt16(value[1])
        }

        var sensorContactSupported = false
        var sensorContactDetected = false
        if (value[0] & 0x6) == 0x6 {
            // Sensor Contact feature is supported and contact is detected
            sensorContactSupported = true
            sensorContactDetected = true
        } else if (value[0] & 0x6) == 0x4 {
            // Sensor Contact feature is supported, but contact is not detected
            sensorContactSupported = true
        }

        var energyExpended: UInt16? = nil
        if (value[0] & 0x8) != 0 {
            // Energy Expended field is present
            if (value[0] & 0x1) != 0 {
                // Heart Rate Value Format is set to UINT16
                energyExpended = UInt16((value[3]<<8) | value[4])
            } else {
                // Heart Rate Value Format is set to UINT8
                energyExpended = UInt16((value[2]<<8) | value[3])
            }
        }

        // Parse RR-Interval values. May be 0, 1, or more values.
        var rrIntervals: [UInt16]? = nil
        if (value[0] & 0x10) != 0 {
            // One or more RR-Interval values are present
            rrIntervals = [UInt16]()
            var start: Int = 0
            if (value[0] & 0x1) != 0 {
                // Heart Rate Value Format is set to UINT16
                if (value[0] & 0x8) != 0 {
                    // Energy Expended field is present
                    start = 5
                } else {
                    // Energy Expended field is not present
                    start = 3
                }
            } else {
                // Heart Rate Value Format is set to UINT8
                if (value[0] & 0x8) != 0 {
                    // Energy Expended field is present
                    start = 4
                } else {
                    // Energy Expended field is not present
                    start = 2
                }
            }

            for i in stride(from: start, to: value.count, by: 2){
                let rrInterval: UInt16 = value[i...i+1].withUnsafeBytes { $0.load(as: UInt16.self) }
                rrIntervals?.append(rrInterval)
            }
        }

        return HeartRateMeasurement(heartRateMeasurementValue: heartRate,
                                    sensorContactSupported: sensorContactSupported,
                                    sensorContactDetected: sensorContactDetected,
                                    energyExpended: energyExpended,
                                    rrInterval: rrIntervals
        )
    }

    static func readString(at i: Int, of data: Data) -> String {
        return String(unsafeUninitializedCapacity: data.count) {
            _ = $0.initialize(from: data)
            return data.count
        }
    }
}
