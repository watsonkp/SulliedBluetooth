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

    // YAML reference of service UUIDs
    //  https://bitbucket.org/bluetooth-SIG/public/src/main/assigned_numbers/uuids/service_uuids.yaml
    static let supportedServices = [SupportedService(id: CBUUID(string: "0x180d"), description: String(describing: CBUUID(string: "0x180d"))),
                                    SupportedService(id: CBUUID(string: "0x180a"), description: String(describing: CBUUID(string: "0x180a"))),
                                    SupportedService(id: CBUUID(string: "0x180f"), description: String(describing: CBUUID(string: "0x180f"))),
                                    SupportedService(id: CBUUID(string: "0x1816"), description: String(describing: CBUUID(string: "0x1816"))),
                                    SupportedService(id: CBUUID(string: "0x1818"), description: "Cycling Power"),
                                    SupportedService(id: CBUUID(string: "0x181c"), description: "User Data"),
                                    SupportedService(id: CBUUID(string: "0x1826"), description: "Fitness Machine")]

    // YAML reference of service UUIDs
    //  https://bitbucket.org/bluetooth-SIG/public/src/main/assigned_numbers/uuids/service_uuids.yaml
    static let supportedNotifyingServices = [SupportedService(id: CBUUID(string: "0x180d"), description: "Heart Rate"),
                                             SupportedService(id: CBUUID(string: "0x180f"), description: "Battery"),
                                             SupportedService(id: CBUUID(string: "0x1816"), description: "Cycling Speed and Cadence"),
                                             SupportedService(id: CBUUID(string: "0x1818"), description: "Cycling Power")]

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
            // YAML reference of characteristic UUIDs
            //  https://bitbucket.org/bluetooth-SIG/public/src/main/assigned_numbers/uuids/characteristic_uuids.yaml
            switch id {
            case CBUUID(string: "0x2A5B"):
                return BluetoothValue.cyclingSpeedAndCadence(CSCMeasurement(value: value))
            case CBUUID(string: "0x2A5D"):
                guard let sensorLocation = SensorLocation(rawValue: value[0]) else {
                    return BluetoothValue.raw(value)
                }
                return BluetoothValue.sensorLocation(sensorLocation)
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
            case CBUUID(string: "0x2A23"):
                guard let id = SystemID(value: value) else {
                    return BluetoothValue.raw(value)
                }
                return BluetoothValue.systemID(id)
            case CBUUID(string: "0x2A24"):
                return BluetoothValue.modelNumber(Bluetooth.readString(at: 0, of: value))
            case CBUUID(string: "0x2A25"):
                return BluetoothValue.serialNumberString(Bluetooth.readString(at: 0, of: value))
            case CBUUID(string: "0x2A26"):
                return BluetoothValue.firmwareRevisionString(Bluetooth.readString(at: 0, of: value))
            case CBUUID(string: "0x2A27"):
                return BluetoothValue.hardwareRevisionString(Bluetooth.readString(at: 0, of: value))
            case CBUUID(string: "0x2A28"):
                return BluetoothValue.softwareRevisionString(Bluetooth.readString(at: 0, of: value))
            case CBUUID(string: "0x2A29"):
                return BluetoothValue.manufacturerNameString(Bluetooth.readString(at: 0, of: value))
            case CBUUID(string: "0x2a37"):
                guard let measurement = HeartRateMeasurement(value: value) else {
                    return BluetoothValue.raw(value)
                }
                return BluetoothValue.heartRateMeasurement(measurement)
            case CBUUID(string: "0x2A38"):
                guard value.count == 1,
                      let bodySensorLocation = BodySensorLocation(rawValue: value[0]) else {
                    return BluetoothValue.raw(value)
                }
                return BluetoothValue.bodySensorLocation(bodySensorLocation)
            case CBUUID(string: "0x2A65"):
                guard let features = Bluetooth.readUInt32(at: 0, of: value) else {
                    return BluetoothValue.raw(value)
                }
                return BluetoothValue.cyclingPowerFeature(CyclingPowerFeature(rawValue: features))
            case CBUUID(string: "0x2A99"):
                guard let increment = Bluetooth.readUInt32(at: 0, of: value) else {
                    return BluetoothValue.raw(value)
                }
                return BluetoothValue.databaseChangeIncrement(increment)
            case CBUUID(string: "0x2A9A"):
                guard let index = value.first else {
                    return BluetoothValue.raw(value)
                }
                return BluetoothValue.userIndex(UserIndex(userIndex: index))
            case CBUUID(string: "0x2ACC"):
                guard let features = FitnessMachineFeature(value: value) else {
                    return BluetoothValue.raw(value)
                }
                return BluetoothValue.fitnessMachineFeature(features)
            case CBUUID(string: "0x2AD6"):
                guard let range = SupportedResistanceLevelRange(value: value) else {
                    return BluetoothValue.raw(value)
                }
                return BluetoothValue.supportedResistanceLevelRange(range)
            case CBUUID(string: "0x2AD8"):
                guard let range = SupportedPowerRange(value: value) else {
                    return BluetoothValue.raw(value)
                }
                return BluetoothValue.supportedPowerRange(range)
            default:
                return BluetoothValue.raw(value)
            }
        }
        return BluetoothValue.none
    }
}
