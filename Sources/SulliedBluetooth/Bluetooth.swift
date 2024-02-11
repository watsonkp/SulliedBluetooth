import Foundation
import CoreBluetooth

public struct Bluetooth {
    private static let bluetoothBaseUUID = Array<UInt8>([0x00, 0x00, 0x10, 0x00, 0x80, 0x00, 0x00, 0x80, 0x5f, 0x9b, 0x34, 0xfb])
        .withUnsafeBufferPointer({ Data(buffer: $0) })
    private static let baseMemberUUID = Array<UInt8>([0xf0, 0x00])
        .withUnsafeBufferPointer({ Data(buffer: $0) })
    static func isAssignedNumber(_ id: CBUUID) -> Bool {
        // Companies can request 16 bit IDs. They are all above 0xF000.
        if id.data.count == 2 && id.data[0] >= Bluetooth.baseMemberUUID[0] {
            return false
        }
        // Pre-allocated UUIDs are shifted left 96 bits and added to the Bluetooth base UUID of 00000000-0000-1000-8000-00805F9B34FB
        // Bluetooth Core specification 5.3 Part B Section 2.5.1 page 1181
        if (id.data.count == 2) || (id.data.count == 4) || ((id.data.count == 16) && (Bluetooth.bluetoothBaseUUID == id.data[4 ..< 16])) {
            return true
        } else {
            return false
        }
    }

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

    static func readUInt32(at i: Int, of data: Data) -> UInt32? {
        guard i + 3 < data.count else {
            return nil
        }
        return UInt32(data[i]) | UInt32(data[i+1])<<8 | UInt32(data[i+2])<<16 | UInt32(data[i+3])<<24
    }

    static func readString(at i: Int, of data: Data) -> String {
        return String(unsafeUninitializedCapacity: data.count) {
            _ = $0.initialize(from: data)
            return data.count
        }
    }
}
