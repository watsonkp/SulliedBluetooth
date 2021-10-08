import CoreBluetooth

public class BluetoothModel: ObservableObject {
    @Published var peripherals = [PeripheralModel]()
    @Published var connectedPeripherals = [PeripheralModel]()
}

struct ValueModel: CustomStringConvertible {
    let id: CBUUID
    let value: Data?
    var description: String {
        return "\(ValueModel.decode(id: id, value: value))"
    }

    static func decode(id: CBUUID, value: Data?) -> String {
        // TODO: Check if characteristic has the read property first
        // TODO: Check if utf8 string decoding is safe and tolerant of malformed utf8. See docs of the String initializer for guidance
        if let value = value {
            switch id {
            case CBUUID(string: "0x2a19"):
                // https://www.bluetooth.com/wp-content/uploads/Sitecore-Media-Library/Gatt/Xml/Characteristics/org.bluetooth.characteristic.battery_level.xml
                var typedValue = [UInt8](repeating:0, count: 1)
                typedValue.withUnsafeMutableBytes({(bs: UnsafeMutableRawBufferPointer) -> Void in
                    value.copyBytes(to: bs, count: value.count)
                })
                return "\(String(typedValue[0]))%"
            case CBUUID(string: "0x2a23"):
                // https://www.bluetooth.com/wp-content/uploads/Sitecore-Media-Library/Gatt/Xml/Characteristics/org.bluetooth.characteristic.system_id.xml
                var typedValue = [UInt8](repeating:0, count: value.count)
                typedValue.withUnsafeMutableBytes({(bs: UnsafeMutableRawBufferPointer) -> Void in
                    value.copyBytes(to: bs, count: value.count)
                })

                let secondField = typedValue.suffix(from: 5)
                var oui: UInt64 = 0
                for i in secondField.startIndex ..< secondField.endIndex {
                    oui += UInt64(secondField[i]) << (8 * (i-secondField.startIndex))
                }

                // If System ID is based on a Bluetooth Device Address
                if (typedValue[3] == 0xfe) && (typedValue[4] == 0xff) {
                    let field = typedValue.prefix(3)
                    var cai: UInt64 = 0
                    for i in field.startIndex ..< field.endIndex {
                        cai += UInt64(field[i]) << (8 * i)
                    }
                    return String(format: "CAI: %X, OUI: %X", cai, oui)
                }

                let firstField = typedValue.prefix(5)
                var lso: UInt64 = 0
                for i in firstField.startIndex ..< firstField.endIndex {
                    lso += UInt64(firstField[i]) << (8 * i)
                }
                return String(format: "MI:%lX, OUI: %X", lso, oui)
            case CBUUID(string: "0x2a24"):
                // https://www.bluetooth.com/wp-content/uploads/Sitecore-Media-Library/Gatt/Xml/Characteristics/org.bluetooth.characteristic.model_number_string.xml
                var typedValue = [UInt8](repeating:0, count: value.count)
                typedValue.withUnsafeMutableBytes({(bs: UnsafeMutableRawBufferPointer) -> Void in
                    value.copyBytes(to: bs, count: value.count)
                })
                return String(unsafeUninitializedCapacity: typedValue.count) {
                    _ = $0.initialize(from: typedValue)
                    return typedValue.count
                }
            case CBUUID(string: "0x2a25"):
                // https://www.bluetooth.com/wp-content/uploads/Sitecore-Media-Library/Gatt/Xml/Characteristics/org.bluetooth.characteristic.serial_number_string.xml
                var typedValue = [UInt8](repeating:0, count: value.count)
                typedValue.withUnsafeMutableBytes({(bs: UnsafeMutableRawBufferPointer) -> Void in
                    value.copyBytes(to: bs, count: value.count)
                })
                return String(unsafeUninitializedCapacity: typedValue.count) {
                    _ = $0.initialize(from: typedValue)
                    return typedValue.count
                }
            case CBUUID(string: "0x2a26"):
                // https://www.bluetooth.com/wp-content/uploads/Sitecore-Media-Library/Gatt/Xml/Characteristics/org.bluetooth.characteristic.firmware_revision_string.xml
                var typedValue = [UInt8](repeating:0, count: value.count)
                typedValue.withUnsafeMutableBytes({(bs: UnsafeMutableRawBufferPointer) -> Void in
                    value.copyBytes(to: bs, count: value.count)
                })
                return String(unsafeUninitializedCapacity: typedValue.count) {
                    _ = $0.initialize(from: typedValue)
                    return typedValue.count
                }
            case CBUUID(string: "0x2a27"):
                // https://www.bluetooth.com/wp-content/uploads/Sitecore-Media-Library/Gatt/Xml/Characteristics/org.bluetooth.characteristic.hardware_revision_string.xml
                var typedValue = [UInt8](repeating:0, count: value.count)
                typedValue.withUnsafeMutableBytes({(bs: UnsafeMutableRawBufferPointer) -> Void in
                    value.copyBytes(to: bs, count: value.count)
                })
                return String(unsafeUninitializedCapacity: typedValue.count) {
                    _ = $0.initialize(from: typedValue)
                    return typedValue.count
                }
            case CBUUID(string: "0x2a28"):
                // https://www.bluetooth.com/wp-content/uploads/Sitecore-Media-Library/Gatt/Xml/Characteristics/org.bluetooth.characteristic.software_revision_string.xml
                var typedValue = [UInt8](repeating:0, count: value.count)
                typedValue.withUnsafeMutableBytes({(bs: UnsafeMutableRawBufferPointer) -> Void in
                    value.copyBytes(to: bs, count: value.count)
                })
                return String(unsafeUninitializedCapacity: typedValue.count) {
                    _ = $0.initialize(from: typedValue)
                    return typedValue.count
                }
            case CBUUID(string: "0x2a29"):
                // https://www.bluetooth.com/wp-content/uploads/Sitecore-Media-Library/Gatt/Xml/Characteristics/org.bluetooth.characteristic.manufacturer_name_string.xml
                var typedValue = [UInt8](repeating:0, count: value.count)
                typedValue.withUnsafeMutableBytes({(bs: UnsafeMutableRawBufferPointer) -> Void in
                    value.copyBytes(to: bs, count: value.count)
                })
                return String(unsafeUninitializedCapacity: typedValue.count) {
                    _ = $0.initialize(from: typedValue)
                    return typedValue.count
                }
            case CBUUID(string: "0x2a37"):
                // https://www.bluetooth.com/wp-content/uploads/Sitecore-Media-Library/Gatt/Xml/Characteristics/org.bluetooth.characteristic.heart_rate_measurement.xml
                var typedValue = [UInt8](repeating:0, count: 0xf)
                typedValue.withUnsafeMutableBytes({(bs: UnsafeMutableRawBufferPointer) -> Void in
                    value.copyBytes(to: bs, count: value.count)
                })

                var heartRate: Int = -1
                switch value[0] & 0x11 {
                case 0x0:
                    heartRate = Int(value[1])
                case 0x1:
                    heartRate = Int(UInt16((value[1]<<8) | value[2]))
                case 0x10:
                    heartRate = Int(value[1])
                case 0x11:
                    heartRate = Int(UInt16((value[1]<<8) | value[2]))
                default:
                    NSLog("ERROR: Unexpected heart rate format")
                }
                return String(heartRate)
            case CBUUID(string: "0x2a38"):
                // https://www.bluetooth.com/wp-content/uploads/Sitecore-Media-Library/Gatt/Xml/Characteristics/org.bluetooth.characteristic.body_sensor_location.xml
                var typedValue = [UInt8](repeating:0, count: value.count)
                typedValue.withUnsafeMutableBytes({(bs: UnsafeMutableRawBufferPointer) -> Void in
                    value.copyBytes(to: bs, count: value.count)
                })
                switch typedValue[0] {
                case 0x0:
                    return "Other"
                case 0x1:
                    return "Chest"
                case 0x2:
                    return "Wrist"
                case 0x3:
                    return "Finger"
                case 0x4:
                    return "Hand"
                case 0x5:
                    return "Ear Lobe"
                case 0x6:
                    return "Foot"
                default:
                    return "Reserved for future use"
                }
            case CBUUID(string: "0x2a99"):
                // https://www.bluetooth.com/wp-content/uploads/Sitecore-Media-Library/Gatt/Xml/Characteristics/org.bluetooth.characteristic.database_change_increment.xml
                var typedValue = [UInt32](repeating:0, count: 1)
                typedValue.withUnsafeMutableBytes({(bs: UnsafeMutableRawBufferPointer) -> Void in
                    value.copyBytes(to: bs, count: value.count)
                })
                return String(typedValue[0])
            case CBUUID(string: "0x2a9a"):
                // https://www.bluetooth.com/wp-content/uploads/Sitecore-Media-Library/Gatt/Xml/Characteristics/org.bluetooth.characteristic.user_index.xml
                var typedValue = [UInt8](repeating:0, count: 1)
                typedValue.withUnsafeMutableBytes({(bs: UnsafeMutableRawBufferPointer) -> Void in
                    value.copyBytes(to: bs, count: value.count)
                })
                if typedValue[0] == 255 {
                    return "Unknown User"
                }
                return "nil"
            default:
                return value.base64EncodedString()
            }
        } else {
            return "nil"
        }
    }
}
