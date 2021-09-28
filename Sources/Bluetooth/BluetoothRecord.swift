import CoreBluetooth

public struct BluetoothRecord {
    public let peripheral: UUID
    public let uuid: CBUUID
    public let name: String
    public let timestamp: Date
    public let value: BluetoothValue

    init(characteristic: CBCharacteristic, timestamp: Date) {
        self.peripheral = characteristic.service!.peripheral!.identifier
        self.uuid = characteristic.uuid
        self.name = "\(characteristic.uuid)"
        self.timestamp = timestamp
        self.value = BluetoothRecord.decode(id: self.uuid, value: characteristic.value)
    }

    static func decode(id: CBUUID, value: Data?) -> BluetoothValue {
        if let value = value {
            switch id {
            case CBUUID(string: "0x2a19"):
                // https://www.bluetooth.com/wp-content/uploads/Sitecore-Media-Library/Gatt/Xml/Characteristics/org.bluetooth.characteristic.battery_level.xml
                var typedValue = [UInt8](repeating:0, count: 1)
                typedValue.withUnsafeMutableBytes({(bs: UnsafeMutableRawBufferPointer) -> Void in
                    value.copyBytes(to: bs, count: value.count)
                })
                return BluetoothValue.batteryLevel(typedValue[0])
            case CBUUID(string: "0x2a37"):
                // https://www.bluetooth.com/wp-content/uploads/Sitecore-Media-Library/Gatt/Xml/Characteristics/org.bluetooth.characteristic.heart_rate_measurement.xml
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

                // TODO: Parse multiple RR-Interval values
                var rrIntervals: [UInt16]? = nil
                if (value[0] & 0x10) != 0 {
                    // One or more RR-Interval values are present
                    if (value[0] & 0x1) != 0 {
                        // Heart Rate Value Format is set to UINT16
                        if (value[0] & 0x8) != 0 {
                            // Energy Expended field is present
                            rrIntervals = [UInt16((value[5]<<8) | value[6])]
                        } else {
                            // Energy Expended field is not present
                            rrIntervals = [UInt16((value[3]<<8) | value[4])]
                        }
                    } else {
                        // Heart Rate Value Format is set to UINT8
                        if (value[0] & 0x8) != 0 {
                            // Energy Expended field is present
                            rrIntervals = [UInt16((value[4]<<8) | value[5])]
                        } else {
                            // Energy Expended field is not present
                            rrIntervals = [UInt16((value[2]<<8) | value[3])]
                        }
                    }
                }

                return BluetoothValue.heartRateMeasurement(HeartRateMeasurement(heartRateMeasurementValue: heartRate,
                                                                                sensorContactSupported: sensorContactSupported,
                                                                                sensorContactDetected: sensorContactDetected,
                                                                                energyExpended: energyExpended,
                                                                                rrInterval: rrIntervals))
            default:
                return BluetoothValue.raw(value)
            }
        }
        return BluetoothValue.none
    }
}

public enum BluetoothValue {
    case batteryLevel(UInt8)
    case heartRateMeasurement(HeartRateMeasurement)
    case raw(Data)
    case none
}

public struct HeartRateMeasurement {
    public let heartRateMeasurementValue: UInt16
    public let sensorContactSupported: Bool
    public let sensorContactDetected: Bool
    public let energyExpended: UInt16?
    public let rrInterval: [UInt16]?
}
