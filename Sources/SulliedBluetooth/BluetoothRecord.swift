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

public enum BluetoothValue: CustomStringConvertible {
    case batteryLevel(UInt8)
    case cyclingPower(CyclingPowerMeasurement)
    case systemID(SystemID)
    case modelNumber(String)
    case serialNumberString(String)
    case firmwareRevisionString(String)
    case hardwareRevisionString(String)
    case softwareRevisionString(String)
    case manufacturerNameString(String)
    case cyclingSpeedAndCadence(CSCMeasurement)
    case sensorLocation(SensorLocation)
    case heartRateMeasurement(HeartRateMeasurement)
    case bodySensorLocation(BodySensorLocation)
    case cyclingPowerFeature(CyclingPowerFeature)
    case databaseChangeIncrement(UInt32)
    case userIndex(UserIndex)
    case fitnessMachineFeature(FitnessMachineFeature)
    case supportedResistanceLevelRange(SupportedResistanceLevelRange)
    case supportedPowerRange(SupportedPowerRange)
    case raw(Data)
    case none
    public var description: String {
        get {
            switch self {
            case .batteryLevel(let level):
                return "\(level)%"
            case .cyclingPower(let measurement):
                return String(describing: measurement)
            case .systemID(let id):
                return String(describing: id)
            case .modelNumber(let modelNumber):
                return modelNumber
            case .serialNumberString(let serialNumber):
                return serialNumber
            case .firmwareRevisionString(let firmwareRevision):
                return firmwareRevision
            case .hardwareRevisionString(let hardwareRevision):
                return hardwareRevision
            case .softwareRevisionString(let softwareRevision):
                return softwareRevision
            case .manufacturerNameString(let manufacturerName):
                return manufacturerName
            case .cyclingSpeedAndCadence(let speed):
                return "\(speed)"
            case .sensorLocation(let location):
                return String(describing: location)
            case .heartRateMeasurement(let measurement):
                return "\(measurement)"
            case .bodySensorLocation(let location):
                return String(describing: location)
            case .cyclingPowerFeature(let features):
                return String(describing: features)
            case .databaseChangeIncrement(let increment):
                return "\(increment)"
            case .userIndex(let index):
                return String(describing: index)
            case .fitnessMachineFeature(let features):
                return String(describing: features)
            case .supportedResistanceLevelRange(let range):
                return String(describing: range)
            case .supportedPowerRange(let range):
                return String(describing: range)
            case .raw(let data):
                return "\(data)"
            case .none:
                return "none"
            }
        }
    }

    public var fieldDescriptions: [String : String] {
        get {
            switch self {
            case .batteryLevel(let level):
                return ["Battery Level" : "\(level)%"]
            case .cyclingPower(let measurement):
                return measurement.fieldDescriptions
            case .systemID(let id):
                return id.fieldDescriptions
            case .modelNumber(let modelNumber):
                return ["Model Number" : modelNumber]
            case .serialNumberString(let serialNumber):
                return ["Serial Number" : serialNumber]
            case .firmwareRevisionString(let firmwareRevision):
                return ["Firmware Revision" : firmwareRevision]
            case .hardwareRevisionString(let hardwareRevision):
                return ["Hardware Revision" : hardwareRevision]
            case .softwareRevisionString(let softwareRevision):
                return ["Software Revision" : softwareRevision]
            case .manufacturerNameString(let manufacturerName):
                return ["Manufacturer Name" : manufacturerName]
            case .cyclingSpeedAndCadence(let speed):
                return speed.fieldDescriptions
            case .sensorLocation(let location):
                return ["Sensor Location" : String(describing: location)]
            case .heartRateMeasurement(let measurement):
                return measurement.fieldDescriptions
            case .bodySensorLocation(let location):
                return ["Body Sensor Location" : String(describing: location)]
            case .cyclingPowerFeature(let features):
                return features.fieldDescriptions
            case .databaseChangeIncrement(let increment):
                return ["Database Change Increment" : "\(increment)"]
            case .userIndex(let index):
                return ["User Index" : String(describing: index)]
            case .fitnessMachineFeature(let features):
                return features.fieldDescriptions
            case .supportedResistanceLevelRange(let range):
                return range.fieldDescriptions
            case .supportedPowerRange(let range):
                return range.fieldDescriptions
            case .raw(let data):
                return ["Unrecognized" : "\(data)"]
            case .none:
                return [:]
            }
        }
    }
}
