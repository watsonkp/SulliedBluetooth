import CoreBluetooth

class PeripheralModel: ObservableObject {
    @Published var services = [ServiceModel]()
    @Published var didFail = false
    @Published var errorMessage = ""
    var identifier: UUID
    var name: String?
    @Published var connectionState: CBPeripheralState

    init(_ peripheral: CBPeripheral) {
        self.identifier = peripheral.identifier
        self.name = peripheral.name
        self.connectionState = peripheral.state
    }
    
    init(identifier: UUID, name: String, state: CBPeripheralState = .disconnected) {
        self.identifier = identifier
        self.name = name
        self.connectionState = state
    }
}
