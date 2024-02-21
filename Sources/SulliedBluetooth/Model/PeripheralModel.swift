import CoreBluetooth

class PeripheralModel: ObservableObject {
    @Published var services = [ServiceModel]()
    @Published var didFail = false
    @Published var errorMessage = ""
    var identifier: UUID
    var name: String?
    @Published var connectionState: CBPeripheralState
    @Published var rssi: Int? = nil

    init(_ peripheral: CBPeripheral, rssi: NSNumber? = nil) {
        self.identifier = peripheral.identifier
        self.name = peripheral.name
        self.connectionState = peripheral.state
        self.rssi = rssi?.intValue
    }
    
    init(identifier: UUID, name: String?, state: CBPeripheralState = .disconnected, rssi: Int? = nil) {
        self.identifier = identifier
        self.name = name
        self.connectionState = state
        self.rssi = rssi
    }
}
