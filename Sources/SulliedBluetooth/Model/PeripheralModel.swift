import CoreBluetooth

class PeripheralModel: ObservableObject {
    @Published var services = [ServiceModel]()
    @Published var didFail = false
    @Published var errorMessage = ""
    var identifier: UUID
    var name: String?
    @Published var connectionState: CBPeripheralState
//    @Published var rssi: Int? = nil
//    let advertisedServices: [CBUUID]?

    init(_ peripheral: CBPeripheral) {
        self.identifier = peripheral.identifier
        self.name = peripheral.name
        self.connectionState = peripheral.state
//        self.rssi = rssi?.intValue
//        self.advertisedServices = services
    }
    
    init(identifier: UUID, name: String?, state: CBPeripheralState = .disconnected) {
        self.identifier = identifier
        self.name = name
        self.connectionState = state
//        self.rssi = rssi
//        self.advertisedServices = services
    }
}
