import CoreBluetooth

public struct BluetoothRecord {
    public let peripheral: UUID
    public let uuid: CBUUID
    public let name: String
    public let timestamp: Date
    public let value: Any
}
