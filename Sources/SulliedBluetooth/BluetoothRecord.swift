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
        self.value = Bluetooth.decode(characteristic: self.uuid, from: characteristic.value)
        // TODO: Remove these properties. Added temporarily for backwards compatibility.
        self.raw = characteristic.value!
        self.serviceUUID = characteristic.service!.uuid
    }
}
