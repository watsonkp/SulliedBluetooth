import CoreBluetooth
import SulliedMeasurement



public struct BluetoothRecord {
    public let peripheral: UUID
    public let uuid: CBUUID
    public let name: String
    public let timestamp: Date
    public let value: BluetoothValue
    public let raw: Data
    public let serviceUUID: CBUUID

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
