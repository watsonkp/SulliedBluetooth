import CoreBluetooth

class CharacteristicModel: ObservableObject {
    var characteristic: CBCharacteristic?
    var uuid: CBUUID
    var properties: CBCharacteristicProperties
    var canNotify: Bool {
        get {
            properties.contains(.notify)
        }
    }
    var canRecord: Bool {
        get {
            canNotify && PeripheralController.supportedRecordingCharacteristics.contains(uuid)
        }
    }
    @Published var value: Data? = nil
    @Published var isNotifying: Bool = false

    var name: String {
        CharacteristicUUIDDescriptions[self.uuid] ?? self.uuid.uuidString
    }

    var parsedValue: BluetoothValue {
        get {
            BluetoothRecord.decode(characteristic: uuid, value: characteristic?.value ?? value)
        }
    }

    var fields: [FieldModel] {
        get {
            parsedValue.fieldDescriptions.map { FieldModel(characteristicID: uuid, valueDescription: $0) }
        }
    }

    var isAssignedNumber: Bool {
        get {
            Bluetooth.isAssignedNumber(uuid)
        }
    }

//    var parsedValue: ValueModel {
//        get {
//            return ValueModel(id: uuid, value: characteristic?.value ?? value)
//        }
//    }

    init(_ characteristic: CBCharacteristic) {
        self.characteristic = characteristic
        self.uuid = characteristic.uuid
        self.properties = characteristic.properties
    }

    // For design time previews and simulators
    init(uuid: CBUUID, properties: CBCharacteristicProperties) {
        self.uuid = uuid
        self.properties = properties
    }
}
