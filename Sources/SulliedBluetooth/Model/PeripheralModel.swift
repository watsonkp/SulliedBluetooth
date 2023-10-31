import CoreBluetooth

class PeripheralModel: ObservableObject {
    @Published var services = [ServiceModel]()
    @Published var didFail = false
    @Published var errorMessage = ""
    var identifier: UUID
    var name: String?

    init(_ peripheral: CBPeripheral) {
        self.identifier = peripheral.identifier
        self.name = peripheral.name
    }
    
    init(identifier: UUID, name: String) {
        self.identifier = identifier
        self.name = name
    }
}
