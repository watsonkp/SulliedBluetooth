import CoreBluetooth

class ServiceModel: ObservableObject {
    @Published var characteristics = [CharacteristicModel]()
    var uuid: CBUUID
    private static let serviceNames: [CBUUID: String] = [CBUUID(string: "0x180d"): "Heart Rate",
                                                         CBUUID(string: "0x180a"): "Device Information",
                                                         CBUUID(string: "0x180f"): "Battery",
                                                         CBUUID(string: "0x181c"): "User Data"]

    var name: String {
        if let name = ServiceModel.serviceNames[self.uuid] {
            return name
        } else {
            return self.uuid.uuidString
        }
    }
    
    init(_ service: CBService) {
        self.uuid = service.uuid
    }
    
    init(uuid: CBUUID) {
        self.uuid = uuid
    }
}
