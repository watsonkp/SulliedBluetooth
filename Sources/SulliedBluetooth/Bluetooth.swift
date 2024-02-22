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

    // YAML reference of service UUIDs
    //  https://bitbucket.org/bluetooth-SIG/public/src/main/assigned_numbers/uuids/service_uuids.yaml
    static let supportedServices = [
        SupportedService(id: CBUUID(string: "0x180d"), description: "Heart Rate"),
        SupportedService(id: CBUUID(string: "0x180a"), description: "Device Information"),
        SupportedService(id: CBUUID(string: "0x180f"), description: "Battery"),
        SupportedService(id: CBUUID(string: "0x1816"), description: "Cycling Speed and Cadence"),
        SupportedService(id: CBUUID(string: "0x1818"), description: "Cycling Power"),
        SupportedService(id: CBUUID(string: "0x181A"), description: "Environmental Sensing"),
        SupportedService(id: CBUUID(string: "0x181c"), description: "User Data"),
        SupportedService(id: CBUUID(string: "0x1826"), description: "Fitness Machine"),
    ]

    // YAML reference of service UUIDs
    //  https://bitbucket.org/bluetooth-SIG/public/src/main/assigned_numbers/uuids/service_uuids.yaml
    static let supportedNotifyingServices = [
        SupportedService(id: CBUUID(string: "0x180d"), description: "Heart Rate"),
        SupportedService(id: CBUUID(string: "0x180f"), description: "Battery"),
        SupportedService(id: CBUUID(string: "0x1816"), description: "Cycling Speed and Cadence"),
        SupportedService(id: CBUUID(string: "0x1818"), description: "Cycling Power"),
        SupportedService(id: CBUUID(string: "0x181A"), description: "Environmental Sensing"),
    ]

    public static func decode(characteristic id: CBUUID, from value: Data?) -> BluetoothValue {
        if let value = value {
            // YAML reference of characteristic UUIDs
            //  https://bitbucket.org/bluetooth-SIG/public/src/main/assigned_numbers/uuids/characteristic_uuids.yaml
            switch id {
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
            case CBUUID(string: "0x2A2C"):
                guard let angle = MagneticDeclination(from: value) else {
                    return BluetoothValue.raw(value)
                }
                return BluetoothValue.magneticDeclination(angle)
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
            case CBUUID(string: "0x2A65"):
                guard let features = Bluetooth.readUInt32(at: 0, of: value) else {
                    return BluetoothValue.raw(value)
                }
                return BluetoothValue.cyclingPowerFeature(CyclingPowerFeature(rawValue: features))
            case CBUUID(string: "0x2A6E"):
                guard let temperature = Temperature(from: value) else {
                    return BluetoothValue.raw(value)
                }
                return BluetoothValue.temperature(temperature)
            case CBUUID(string: "0x2A6F"):
                guard let humidity = Humidity(from: value) else {
                    return BluetoothValue.raw(value)
                }
                return BluetoothValue.humidity(humidity)
            case CBUUID(string: "0x2A72"):
                guard let speed = ApparentWindSpeed(from: value) else {
                    return BluetoothValue.raw(value)
                }
                return BluetoothValue.apparentWindSpeed(speed)
            case CBUUID(string: "0x2A73"):
                guard let direction = ApparentWindDirection(from: value) else {
                    return BluetoothValue.raw(value)
                }
                return BluetoothValue.apparentWindDirection(direction)
            case CBUUID(string: "0x2A74"):
                guard let factor = GustFactor(from: value) else {
                    return BluetoothValue.raw(value)
                }
                return BluetoothValue.gustFactor(factor)
            case CBUUID(string: "0x2A77"):
                guard let irradiance = Irradiance(from: value) else {
                    return BluetoothValue.raw(value)
                }
                return BluetoothValue.irradiance(irradiance)
            case CBUUID(string: "0x2A7B"):
                guard let temperature = DewPoint(from: value) else {
                    return BluetoothValue.raw(value)
                }
                return BluetoothValue.dewPoint(temperature)
            case CBUUID(string: "0x2A7A"):
                guard let temperature = HeatIndex(from: value) else {
                    return BluetoothValue.raw(value)
                }
                return BluetoothValue.heatIndex(temperature)
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
            case CBUUID(string: "0x2AA3"):
                guard let trend = BarometricPressureTrend(from: value) else {
                    return BluetoothValue.raw(value)
                }
                return BluetoothValue.barometricPressureTrend(trend)
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
            case CBUUID(string: "0x2B8C"):
                guard let co2 = CO2Concentration(from: value) else {
                    return BluetoothValue.raw(value)
                }
                return BluetoothValue.co2Concentration(co2)
            default:
                return BluetoothValue.unsupported(UnsupportedMeasurement(forCharacteristic: id, from: value))
            }
        }
        return BluetoothValue.none
    }
}
