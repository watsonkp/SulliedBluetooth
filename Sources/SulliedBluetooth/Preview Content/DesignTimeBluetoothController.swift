import CoreBluetooth
import Combine
import SulliedMeasurement

public class DesignTimeBluetoothController: BluetoothControllerProtocol {
    public var model: BluetoothModel = BluetoothModel()
    private var bluetoothPublisher = PassthroughSubject<IntegerDataPoint, Never>()
    public var publisher: AnyPublisher<IntegerDataPoint, Never>
    public var peripheralControllers = [UUID: PeripheralControllerProtocol]()
    private var subscriptions: [AnyCancellable] = []
    var isScanning = false
    
    public func toggleScan(serviceFilter: Set<CBUUID> = []) {
        if isScanning {
            isScanning = false
        } else if model.peripherals.count == 0 {
            model.peripherals.append(DesignTimeModel.populatedPeripheral())
            model.peripherals.append(DesignTimeModel.populatedPeripheral())
            isScanning = true
        } else {
            isScanning = true
        }
    }
    
    public init() {
        self.publisher = AnyPublisher(Publishers.Buffer(upstream: self.bluetoothPublisher,
                                                        size: 12,
                                                        prefetch: .byRequest,
                                                        whenFull: .dropOldest)
        )
    }

    public func connect(_ id: UUID) {
        if let index = model.peripherals.firstIndex(where: { $0.identifier == id }) {
            let peripheral = model.peripherals[index]
            model.peripherals.remove(at: index)
            model.connectedPeripherals.append(peripheral)
            let controller = DesignTimePeripheralController(model: peripheral)
            controller.recordPublisher.sink(receiveValue: { self.bluetoothPublisher.send($0) })
                .store(in: &subscriptions)
            peripheralControllers[peripheral.identifier] = controller
        }
    }

    public func disconnect(indices: IndexSet) {
        let ids = indices.map { model.connectedPeripherals[$0].identifier }

        for id in ids {
            disconnect(id)
        }
    }

    public func disconnect(_ id: UUID) {
        model.connectedPeripherals.removeAll(where: { $0.identifier == id })
        peripheralControllers.removeValue(forKey: id)
    }

    public func disconnectAll() {
        model.connectedPeripherals = []
        peripheralControllers.removeAll()
    }

    public func filterConnectedPeripherals() {
        let connectedIDs = Set<UUID>(model.connectedPeripherals.map { $0.identifier })
        model.peripherals.removeAll(where: { connectedIDs.contains($0.identifier) })
    }
}



class DesignTimeModel {
    static func populatedModel() {
        
    }
    
    static func populatedPeripheral() -> PeripheralModel {
        let peripheral = PeripheralModel(identifier: UUID(), name: "Polar H10")
        peripheral.services.append(populatedService())
        peripheral.services.append(batteryService())
        return peripheral
    }
    
    static func populatedService() -> ServiceModel {
        return heartRateService()
    }
    
    static func heartRateService() -> ServiceModel {
        let service = ServiceModel(uuid: CBUUID(string: "0x180d"))
//        let characteristic = CharacteristicModel(uuid: CBUUID(string: "0x2a37"), properties: [.notify])
//        characteristic.isNotifying = true
        service.characteristics.append(heartRateCharacteristic())
        return service
    }
    
    static func batteryService() -> ServiceModel {
        let service = ServiceModel(uuid: CBUUID(string: "0x180f"))
        let characteristic = CharacteristicModel(uuid: CBUUID(string: "0x2a19"), properties: [.notify])
        characteristic.isNotifying = false
        service.characteristics.append(characteristic)
        return service
    }
    
    static func populatedCharacteristic() -> CharacteristicModel {
        return heartRateCharacteristic()
    }
    
    static func heartRateCharacteristic() -> CharacteristicModel {
        let characteristic = CharacteristicModel(uuid: CBUUID(string: "0x2a37"), properties: [.notify])
        characteristic.isNotifying = true
        return characteristic
    }
}

//struct DesignTimeBluetoothPeripheral: PeripheralProtocol {
//    let name: String?
//    let identifier: UUID
//    func setNotifyValue(_ enabled: Bool, for characteristic: CBCharacteristic) {
//        NSLog("Set notify to \(enabled) for \(characteristic.uuid.uuidString)")
//    }
//}
//
//struct DesignTimeBluetoothService: ServiceProtocol {
//    let uuid: CBUUID
//}

//struct DesignTimeBluetoothCharacteristic: CharacteristicProtocol {
//    let uuid: CBUUID
//    let properties: CBCharacteristicProperties
//    let value: Data?
//}

//class DesignTimeCharacteristicModel: CharacteristicModelProtocol {
//    var uuid: CBUUID = CBUUID(string: "0x180d")
//    var name: String = "Heart Rate"
//    var properties: CBCharacteristicProperties = [.notify]
//    var value: String? = "220"
//}

//class DesignTimeBluetoothController: ControllerProtocol {
//    var model: BluetoothModel
//    private var peripherals = [UUID: (Date, PeripheralProtocol)]()
//
//    init() {
//        model = BluetoothModel()
        
//        let peripheral = DesignTimeBluetoothPeripheral(name: "Polar H10", identifier: UUID())
//        self.peripherals[peripheral.identifier] = (Date(), peripheral)
//        model.peripherals.append(peripheral)
//
//        // Add services
//        let heartRateService = DesignTimeBluetoothService(uuid: CBUUID(string: "0x180d"))
//        let deviceInformationService = DesignTimeBluetoothService(uuid: CBUUID(string: "0x180a"))
//        let batteryService = DesignTimeBluetoothService(uuid: CBUUID(string: "0x180f"))
//        let userDataService = DesignTimeBluetoothService(uuid: CBUUID(string: "0x181c"))
//        model.discoveredServices = [heartRateService, deviceInformationService, batteryService, userDataService]
//
//        // Add characteristics to the heart rate service
//        let characteristic1 = DesignTimeBluetoothCharacteristic(uuid: CBUUID(string: "0x2a37"), properties: [.notify], value: nil)
//        let characteristic2 = DesignTimeBluetoothCharacteristic(uuid: CBUUID(string: "0x2a38"), properties: [.read], value: Data(base64Encoded: "AQ=="))
//        model.discoveredCharacteristics[heartRateService.uuid] = [characteristic1, characteristic2]
//        model.discoveredCharacteristicValues[characteristic2.uuid] = BluetoothModel.decodeCharacteristic(characteristic2)
//
//        // Add characteristics to the device information service
//        let systemIDCharacteristic = DesignTimeBluetoothCharacteristic(uuid: CBUUID(string: "0x2a23"), properties: [.read], value: Data(base64Encoded: "Gcp1/v8anqA="))
//        let modelNumberStringCharacteristic = DesignTimeBluetoothCharacteristic(uuid: CBUUID(string: "0x2a24"), properties: [.read], value: Data(base64Encoded: "SDEwAA=="))
//        let serialNumberStringCharacteristic = DesignTimeBluetoothCharacteristic(uuid: CBUUID(string: "0x2a25"), properties: [.read], value: Data(base64Encoded: "NzVDQTE5MkEA"))
//        let firmRevisionStringCharacteristic = DesignTimeBluetoothCharacteristic(uuid: CBUUID(string: "0x2a26"), properties: [.read], value: Data(base64Encoded: "NS4wLjAA"))
//        let hardwareRevisionStringCharacteristic = DesignTimeBluetoothCharacteristic(uuid: CBUUID(string: "0x2a27"), properties: [.read], value: Data(base64Encoded: "MDA3NjA2OTAuMDMA"))
//        let softwareRevisionStringCharacteristic = DesignTimeBluetoothCharacteristic(uuid: CBUUID(string: "0x2a28"), properties: [.read], value: Data(base64Encoded: "My4wLjU2AA=="))
//        let manufacturerNameStringCharacteristic = DesignTimeBluetoothCharacteristic(uuid: CBUUID(string: "0x2a29"), properties: [.read], value: Data(base64Encoded: "UG9sYXIgRWxlY3RybyBPeQA="))
//        model.discoveredCharacteristics[deviceInformationService.uuid] = [systemIDCharacteristic,
//                                                                          modelNumberStringCharacteristic,
//                                                                          serialNumberStringCharacteristic,
//                                                                          firmRevisionStringCharacteristic,
//                                                                          hardwareRevisionStringCharacteristic,
//                                                                          softwareRevisionStringCharacteristic,
//                                                                          manufacturerNameStringCharacteristic]
//        model.discoveredCharacteristicValues[systemIDCharacteristic.uuid] = BluetoothModel.decodeCharacteristic(systemIDCharacteristic)
//        model.discoveredCharacteristicValues[manufacturerNameStringCharacteristic.uuid] = BluetoothModel.decodeCharacteristic(manufacturerNameStringCharacteristic)
//        model.discoveredCharacteristicValues[modelNumberStringCharacteristic.uuid] = BluetoothModel.decodeCharacteristic(modelNumberStringCharacteristic)
//        model.discoveredCharacteristicValues[serialNumberStringCharacteristic.uuid] = BluetoothModel.decodeCharacteristic(serialNumberStringCharacteristic)
//        model.discoveredCharacteristicValues[firmRevisionStringCharacteristic.uuid] = BluetoothModel.decodeCharacteristic(firmRevisionStringCharacteristic)
//        model.discoveredCharacteristicValues[hardwareRevisionStringCharacteristic.uuid] = BluetoothModel.decodeCharacteristic(hardwareRevisionStringCharacteristic)
//        model.discoveredCharacteristicValues[softwareRevisionStringCharacteristic.uuid] = BluetoothModel.decodeCharacteristic(softwareRevisionStringCharacteristic)
//
//        // Add characteristics to the battery service
//        let batteryLevelCharacteristic = DesignTimeBluetoothCharacteristic(uuid: CBUUID(string: "0x2a19"), properties: [.read, .notify], value: Data(base64Encoded: "ZA=="))
//        model.discoveredCharacteristics[batteryService.uuid] = [batteryLevelCharacteristic]
//        model.discoveredCharacteristicValues[batteryLevelCharacteristic.uuid] = BluetoothModel.decodeCharacteristic(batteryLevelCharacteristic)
//
//        let databaseChangeIncrementCharacteristic = DesignTimeBluetoothCharacteristic(uuid: CBUUID(string: "0x2a99"), properties: [.read, .write], value: Data(base64Encoded: "AAAAAA=="))
//        let userIndexCharacteristic = DesignTimeBluetoothCharacteristic(uuid: CBUUID(string: "0x2a9a"), properties: [.read], value: Data(base64Encoded: "/w=="))
//        let userControlPointCharacteristic = DesignTimeBluetoothCharacteristic(uuid: CBUUID(string: "0x2a9f"), properties: [.write, .indicate], value: nil)
//        let firstNameCharacteristic = DesignTimeBluetoothCharacteristic(uuid: CBUUID(string: "0x2a8a"), properties: [.read, .write], value: nil)
//        let lastNameCharacteristic = DesignTimeBluetoothCharacteristic(uuid: CBUUID(string: "0x2a90"), properties: [.read, .write], value: nil)
//        let ageCharacteristic = DesignTimeBluetoothCharacteristic(uuid: CBUUID(string: "0x2a80"), properties: [.read, .write], value: nil)
//        let genderCharacteristic = DesignTimeBluetoothCharacteristic(uuid: CBUUID(string: "0x2a8c"), properties: [.read, .write], value: nil)
//        let weightCharacteristic = DesignTimeBluetoothCharacteristic(uuid: CBUUID(string: "0x2a98"), properties: [.read, .write], value: nil)
//        let heightCharacteristic = DesignTimeBluetoothCharacteristic(uuid: CBUUID(string: "0x2a8e"), properties: [.read, .write], value: nil)
//        let languageCharacteristic = DesignTimeBluetoothCharacteristic(uuid: CBUUID(string: "0x2aa2"), properties: [.read, .write], value: nil)
//        model.discoveredCharacteristics[userDataService.uuid] = [databaseChangeIncrementCharacteristic,
//                                                                 userIndexCharacteristic,
//                                                                 userControlPointCharacteristic,
//                                                                 firstNameCharacteristic,
//                                                                 lastNameCharacteristic,
//                                                                 ageCharacteristic,
//                                                                 genderCharacteristic,
//                                                                 weightCharacteristic,
//                                                                 heightCharacteristic,
//                                                                 languageCharacteristic]
//        model.discoveredCharacteristicValues[databaseChangeIncrementCharacteristic.uuid] = BluetoothModel.decodeCharacteristic(databaseChangeIncrementCharacteristic)
//        model.discoveredCharacteristicValues[userIndexCharacteristic.uuid] = BluetoothModel.decodeCharacteristic(userIndexCharacteristic)
//        model.discoveredCharacteristicValues[userControlPointCharacteristic.uuid] = BluetoothModel.decodeCharacteristic(userControlPointCharacteristic)
        
        // Add descriptors to characteristics
//            let descriptor1 = DesignTimeBluetoothDescriptor(uuid: CBUUID(string: "0x2902"), value: UUID())
//            model.discoveredDescriptors[characteristic1.uuid] = [descriptor1]
//            let descriptor2 = DesignTimeBluetoothDescriptor(uuid: CBUUID(), value: nil)
//            model.discoveredDescriptors[characteristic1.uuid] = [descriptor2]
//    }
//
//    // TODO: Have some way of surfacing this
//    func toggleScan() {
////        model.isScanning = !(model.isScanning)
//    }
//
//    func connect(_ id: UUID) {
////        if let peripheral = self.peripherals[id]?.1 {
////            model.connectedPeripheral = peripheral.identifier
////        }
//    }
//
//    func notify(peripheralID: UUID, serviceID: CBUUID, enabled: Bool, characteristicID: CBUUID) {
//        // TODO
//    }
//}
