import CoreBluetooth

class CharacteristicModel: ObservableObject {
    var characteristic: CBCharacteristic?
    var uuid: CBUUID
    var properties: CBCharacteristicProperties
    @Published var value: Data? = nil
    @Published var isNotifying: Bool = false
    private static let characteristicNames: [CBUUID: String] = [CBUUID(string: "0x2a19"): "Battery Level",
                                                                CBUUID(string: "0x2a23"): "System ID",
                                                                CBUUID(string: "0x2a24"): "Model Number String",
                                                                CBUUID(string: "0x2a25"): "Serial Number String",
                                                                CBUUID(string: "0x2a26"): "Firmware Revision String",
                                                                CBUUID(string: "0x2a27"): "Hardware Revision String",
                                                                CBUUID(string: "0x2a28"): "Software Revision String",
                                                                CBUUID(string: "0x2a29"): "Manufacturer Name String",
                                                                CBUUID(string: "0x2a37"): "Heart Rate Measurement",
                                                                CBUUID(string: "0x2a38"): "Body Location",
                                                                CBUUID(string: "0x2a5b"): "CSC Measurement",
                                                                CBUUID(string: "0x2a5d"): "Sensor Location",
                                                                CBUUID(string: "0x2a63"): "Cycling Power Measurement",
                                                                CBUUID(string: "0x2a80"): "Age",
                                                                CBUUID(string: "0x2a8a"): "First Name",
                                                                CBUUID(string: "0x2a8c"): "Gender",
                                                                CBUUID(string: "0x2a8e"): "Height",
                                                                CBUUID(string: "0x2a90"): "Last Name",
                                                                CBUUID(string: "0x2a98"): "Weight",
                                                                CBUUID(string: "0x2a99"): "Database Change Increment",
                                                                CBUUID(string: "0x2a9a"): "User Index",
                                                                CBUUID(string: "0x2a9f"): "User Control Point",
                                                                CBUUID(string: "0x2aa2"): "Language"]

    var name: String {
        get {
            if let name = CharacteristicModel.characteristicNames[self.uuid] {
                return name
            } else {
                return self.uuid.uuidString
            }
        }
    }

    var parsedValue: BluetoothValue {
        get {
            BluetoothRecord.decode(characteristic: uuid, value: characteristic?.value ?? value)
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
