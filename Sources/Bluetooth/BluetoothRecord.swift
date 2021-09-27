import CoreBluetooth

struct BluetoothRecord {
    let peripheral: UUID
    let uuid: CBUUID
    let name: String
    let timestamp: Date
    let value: Any
}
