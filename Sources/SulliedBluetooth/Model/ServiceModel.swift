import CoreBluetooth

class ServiceModel: ObservableObject {
    @Published var characteristics = [CharacteristicModel]()
    var uuid: CBUUID

    var name: String {
        ServiceUUIDDescriptions[self.uuid] ?? self.uuid.uuidString
    }
    
    init(_ service: CBService) {
        self.uuid = service.uuid
    }
    
    init(uuid: CBUUID) {
        self.uuid = uuid
    }
}
