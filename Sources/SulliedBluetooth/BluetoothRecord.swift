import CoreBluetooth
import SulliedMeasurement

struct SupportedService: Identifiable, Hashable, CustomStringConvertible {
    let id: CBUUID
    let description: String
}

public struct BluetoothRecord {
    public let peripheral: UUID
    public let uuid: CBUUID
    public let name: String
    public let timestamp: Date
    public let value: BluetoothValue
    public let raw: Data
    public let serviceUUID: CBUUID

    static let supportedServices = [SupportedService(id: CBUUID(string: "0x180d"), description: String(describing: CBUUID(string: "0x180d"))),
                                    SupportedService(id: CBUUID(string: "0x180a"), description: String(describing: CBUUID(string: "0x180a"))),
                                    SupportedService(id: CBUUID(string: "0x180f"), description: String(describing: CBUUID(string: "0x180f"))),
                                    SupportedService(id: CBUUID(string: "0x1816"), description: String(describing: CBUUID(string: "0x1816"))),
                                    SupportedService(id: CBUUID(string: "0x1818"), description: String(describing: CBUUID(string: "0x1818"))),
                                    SupportedService(id: CBUUID(string: "0x181c"), description: "User Data")]

    init(characteristic: CBCharacteristic, timestamp: Date) {
        self.peripheral = characteristic.service!.peripheral!.identifier
        self.uuid = characteristic.uuid
        self.name = "\(characteristic.uuid)"
        self.timestamp = timestamp
        self.value = BluetoothRecord.decode(characteristic: self.uuid, value: characteristic.value)
        // TODO: Remove these properties. Added temporarily for backwards compatibility.
        self.raw = characteristic.value!
        self.serviceUUID = characteristic.service!.uuid
    }

    public static func decode(characteristic id: CBUUID, value: Data?) -> BluetoothValue {
        if let value = value {
            switch id {
            case CBUUID(string: "0x2A5B"):
                // Cycling Speed and Cadence Service 1.0
                //  https://www.bluetooth.com/specifications/specs/cycling-speed-and-cadence-service-1-0/
                var index = 1
                var cumulativeWheelRevolutions: UInt32? = nil
                var wheelEventTime: UInt16? = nil
                if (value[0] & 0x1) != 0 {
                    cumulativeWheelRevolutions = BluetoothRecord.readUInt32(at: index, of: value)
                    index += 4
                    wheelEventTime = BluetoothRecord.readUInt16(at: index, of: value)
                    index += 2
                }

                var cumulativeCrankRevolutions: UInt16? = nil
                var crankEventTime: UInt16? = nil
                if (value[0] & 0x2) != 0 {
                    cumulativeCrankRevolutions = BluetoothRecord.readUInt16(at: index, of: value)
                    index += 2
                    crankEventTime = BluetoothRecord.readUInt16(at: index, of: value)
                    index += 2
                }

                return BluetoothValue.cyclingSpeedAndCadence(CSCMeasurement(cumulativeWheelRevolutions: cumulativeWheelRevolutions,
                                                                            wheelEventTime: wheelEventTime,
                                                                            cumulativeCrankRevolutions: cumulativeCrankRevolutions,
                                                                            crankEventTime: crankEventTime))
            case CBUUID(string: "0x2A63"):
                guard let measurement = CyclingPowerMeasurement(value: value) else {
                    return BluetoothValue.raw(value)
                }
                return BluetoothValue.cyclingPower(measurement)
            case CBUUID(string: "0x2a19"):
                // https://www.bluetooth.com/wp-content/uploads/Sitecore-Media-Library/Gatt/Xml/Characteristics/org.bluetooth.characteristic.battery_level.xml
                var typedValue = [UInt8](repeating:0, count: 1)
                typedValue.withUnsafeMutableBytes({(bs: UnsafeMutableRawBufferPointer) -> Void in
                    value.copyBytes(to: bs, count: value.count)
                })
                return BluetoothValue.batteryLevel(typedValue[0])
            case CBUUID(string: "0x2a37"):
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

                // Parse RR-Interval values. May be 0, 1, or more values up to a maximum of 7 through 9 based on other fields.
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

    private static func readInt16(at i: Int, of data: Data) -> Int16? {
        guard i + 1 < data.count else {
            return nil
        }
        return Int16(data[i])<<8 | Int16(data[i+1])
    }

    private static func readUInt16(at i: Int, of data: Data) -> UInt16? {
        guard i + 1 < data.count else {
            return nil
        }
        return UInt16(data[i])<<8 | UInt16(data[i+1])
    }

    private static func readUInt32(at i: Int, of data: Data) -> UInt32? {
        guard i + 3 < data.count else {
            return nil
        }
        return UInt32(data[i])<<24 | UInt32(data[i+1])<<16 | UInt32(data[i+2])<<8 | UInt32(data[i+3])
    }
}

public enum BluetoothValue: CustomStringConvertible {
    case batteryLevel(UInt8)
    case cyclingPower(CyclingPowerMeasurement)
    case cyclingSpeedAndCadence(CSCMeasurement)
    case heartRateMeasurement(HeartRateMeasurement)
    case raw(Data)
    case none
    public var description: String {
        get {
            switch self {
            case .batteryLevel(let level):
                return "\(level)%"
            case .cyclingPower(let measurement):
                return String(describing: measurement)
            case .cyclingSpeedAndCadence(let speed):
                return "\(speed)"
            case .heartRateMeasurement(let measurement):
                return "\(measurement)"
            case .raw(let data):
                return "\(data)"
            case .none:
                return "none"
            }
        }
    }
}

public struct HeartRateMeasurement: CustomStringConvertible {
    public let heartRateMeasurementValue: UInt16
    public let sensorContactSupported: Bool
    public let sensorContactDetected: Bool
    public let energyExpended: UInt16?
    public let rrInterval: [UInt16]?
    public var description: String {
        get {
            return "\(heartRateMeasurementValue) bpm"
        }
    }

    public init(heartRateMeasurementValue: UInt16, sensorContactSupported: Bool, sensorContactDetected: Bool, energyExpended: UInt16?, rrInterval: [UInt16]?) {
        self.heartRateMeasurementValue = heartRateMeasurementValue
        self.sensorContactSupported = sensorContactSupported
        self.sensorContactDetected = sensorContactDetected
        self.energyExpended = energyExpended
        self.rrInterval = rrInterval
    }
}
