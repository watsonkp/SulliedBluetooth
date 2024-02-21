import CoreBluetooth
import Combine
import SulliedMeasurement

public protocol BluetoothControllerProtocol {
    var model: BluetoothModel { get }
    var publisher: AnyPublisher<IntegerDataPoint, Never> { get }
    var peripheralControllers: [UUID: PeripheralControllerProtocol] { get }
    var isNotifying: Bool { get }
    func toggleScan(serviceFilter: Set<CBUUID>) -> Void
    func connect(_ id: UUID) -> Void
    func disconnect(indices: IndexSet) -> Void
    func disconnect(_ id: UUID) -> Void
    func disconnectAll() -> Void
}

public class BluetoothController: NSObject, CBCentralManagerDelegate, BluetoothControllerProtocol {
    private var manager: CBCentralManager? = nil
    public var model: BluetoothModel = BluetoothModel()
    private let bluetoothBaseUUID = Data(base64Encoded: "AAAQAIAAAIBfmzT7")
    private let baseMemberUUID = Data(base64Encoded: "8AA=")!
    private var discoveredPeripherals = [UUID: (Date, CBPeripheral)]()
    public var peripheralControllers = [UUID: PeripheralControllerProtocol]()
    private var bluetoothPublisher = PassthroughSubject<IntegerDataPoint, Never>()
    public var publisher: AnyPublisher<IntegerDataPoint, Never>
    private var subscriptions: [AnyCancellable] = []
    private var isScanningRequested = false
    private var serviceFilter: [CBUUID]? = nil

    public override init() {
        self.publisher = AnyPublisher(Publishers.Buffer(upstream: self.bluetoothPublisher,
                                                        size: 12,
                                                        prefetch: .byRequest,
                                                        whenFull: .dropOldest)
        )
        super.init()
    }

    public var isNotifying: Bool {
        get {
            peripheralControllers.first(where: { $0.value.isNotifying }) != nil
        }
    }

    private func isBluetoothBaseUUID(_ id: CBUUID) -> Bool {
        // Companies can request 16 bit IDs. They are all above 0xF000.
        if id.data.count == 2 && id.data[0] >= baseMemberUUID[0] {
            return false
        }
        // Pre-allocated UUIDs are shifted left 96 bits and added to the Bluetooth base UUID of 00000000-0000-1000-8000-00805F9B34FB
        // Bluetooth Core specification 5.3 Part B Section 2.5.1 page 1181
        if (id.data.count == 2) || (id.data.count == 4) || ((id.data.count == 16) && (bluetoothBaseUUID == id.data[4 ..< 16])) {
            return true
        } else {
            return false
        }
    }

    public func toggleScan(serviceFilter: Set<CBUUID> = []) {
        self.isScanningRequested.toggle()
        self.serviceFilter = serviceFilter.isEmpty ? nil : Array(serviceFilter)

        // Initialize the CoreBluetooth manager to dispatch events on the main queue.
        if self.isScanningRequested && self.manager == nil {
            self.manager = CBCentralManager(delegate: self, queue: nil)
        }

        // Start scanning for peripherals if it is requested and the manager is powered on.
        if self.isScanningRequested,
           let manager = self.manager,
           !manager.isScanning,
           manager.state == .poweredOn {
            invalidate()
            manager.scanForPeripherals(withServices: serviceFilter.count != 0 ? Array(serviceFilter) : nil, options: nil)
        }

        // Stop scanning for peripherals if the manager is scanning.
        if !self.isScanningRequested,
           let manager = self.manager,
           manager.isScanning{
            manager.stopScan()
        }
    }

    public func connect(_ id: UUID) {
        model.peripherals.first(where: { $0.identifier == id })?.connectionState = .connecting
        if let peripheral = discoveredPeripherals[id]?.1 {
            guard peripheral.state == .disconnected else {
                return
            }
            if let manager = self.manager {
                manager.connect(peripheral, options: nil)
            }
        }
    }

    public func disconnect(indices: IndexSet) {
        let ids = indices.map { model.connectedPeripherals[$0].identifier }

        for id in ids {
            disconnect(id)
        }
    }

    public func disconnect(_ id: UUID) {
        if let peripheral = discoveredPeripherals[id]?.1 {
            manager?.cancelPeripheralConnection(peripheral)
        }
    }

    public func disconnectAll() {
        for peripheral in model.connectedPeripherals {
            disconnect(peripheral.identifier)
        }
    }

    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // Guidance for each state is documented at:
        // https://developer.apple.com/documentation/corebluetooth/cbmanagerstate
        switch central.state {
        // If the state is lower than powered off clear peripheral models.
        //  https://developer.apple.com/documentation/corebluetooth/cbcentralmanagerdelegate/1518888-centralmanagerdidupdatestate
        case CBManagerState.poweredOff:
            // TODO: Report errors in UI or handle. Do not log.
//            NSLog("CoreBluetooth state update: powered off")
            break
        case CBManagerState.poweredOn:
            // Start scanning for peripherals if requested and the manager state is now powered on.
            if isScanningRequested {
                if !central.isScanning {
                    central.scanForPeripherals(withServices: serviceFilter, options: nil)
                }
            }
        case CBManagerState.resetting:
            invalidate()
        case CBManagerState.unauthorized:
            // TODO: Report errors in UI or handle. Do not log.
//            NSLog("CoreBluetooth state: unauthorized")
            invalidate()
        case CBManagerState.unknown:
            // TODO: Report errors in UI or handle. Do not log.
//            NSLog("CoreBluetooth state: unknown")
            invalidate()
        case CBManagerState.unsupported:
            // TODO: Report errors in UI or handle. Do not log.
//            NSLog("CoreBluetooth state: unsupported")
            invalidate()
        default:
            model.errorMessage = "ERROR: Unknown enum value for CBManagerState in BluetoothController.centralManagerDidUpdateState"
            model.didFail = true
        }
    }

//    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
//        NSLog("CoreBluetooth: Restoring central manager during relaunch into background")
//    }

    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // Check for advertisement data specifying that this peripheral is not currently connectable.
        if let isConnectable = advertisementData[CBAdvertisementDataIsConnectable] as? NSNumber,
              isConnectable == 0 {
            return
        }

        if discoveredPeripherals[peripheral.identifier] == nil {
            discoveredPeripherals[peripheral.identifier] = (Date(), peripheral)
            self.model.peripherals.append(PeripheralModel(peripheral))
            NSLog("Peripheral \(peripheral.name ?? peripheral.identifier.uuidString) with RSSI \(RSSI)\nAdvertising:\(advertisementData)")
        }
    }

    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // Remove the peripheral from the published list of discovered peripherals
        self.model.peripherals.removeAll(where: { $0.identifier == peripheral.identifier })

        let peripheralModel = PeripheralModel(peripheral)
        let controller = PeripheralController(peripheral: peripheral, model: peripheralModel)
        controller.recordPublisher.sink(receiveValue: { self.bluetoothPublisher.send($0) })
            .store(in: &subscriptions)
        peripheral.delegate = controller
        peripheralControllers[peripheral.identifier] = controller
        model.connectedPeripherals.append(peripheralModel)

        peripheral.discoverServices(nil)
    }

    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        model.errorMessage = "CoreBluetooth: failed to connect to peripheral: \(peripheral.name ?? peripheral.identifier.uuidString)"
        model.didFail = true
        model.peripherals.append(PeripheralModel(peripheral))
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        // TODO: An AnyCancellable instance automatically calls cancel when deinitialized.
        //  AnyCancellables are stored in subscriptions property.
        //  https://developer.apple.com/documentation/combine/anycancellable
        model.connectedPeripherals.removeAll(where: { $0.identifier == peripheral.identifier })
        peripheralControllers.removeValue(forKey: peripheral.identifier)
        model.peripherals.append(PeripheralModel(peripheral))
    }

    private func invalidate() {
        for peripheral in model.connectedPeripherals {
            disconnect(peripheral.identifier)
        }
        model.connectedPeripherals = []
        model.peripherals = []
        peripheralControllers = [:]
        discoveredPeripherals = [:]
    }
}
