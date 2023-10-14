import CoreBluetooth
import Combine
import SulliedMeasurement

public protocol BluetoothControllerProtocol {
    var model: BluetoothModel { get }
    var peripheralControllers: [UUID: PeripheralControllerProtocol] { get }
    func toggleScan() -> Void
    func connect(_ id: UUID) -> Void
    func filterConnectedPeripherals() -> Void
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
    private var didConnect = Set<UUID>()
    private var isScanningRequested = false

    public override init() {
        self.publisher = AnyPublisher(Publishers.Buffer(upstream: self.bluetoothPublisher,
                                                        size: 12,
                                                        prefetch: .byRequest,
                                                        whenFull: .dropOldest)
        )
        super.init()
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

    public func toggleScan() {
        self.isScanningRequested.toggle()

        // Initialize the CoreBluetooth manager to dispatch events on the main queue.
        if self.isScanningRequested && self.manager == nil {
            self.manager = CBCentralManager(delegate: self, queue: nil)
        }

        // Start scanning for peripherals if it is requested and the manager is powered on.
        if self.isScanningRequested,
           let manager = self.manager,
           !manager.isScanning,
           manager.state == .poweredOn {
            manager.scanForPeripherals(withServices: [CBUUID(string: "0x180d")], options: nil)
        }

        // Stop scanning for peripherals if the manager is scanning.
        if !self.isScanningRequested,
           let manager = self.manager,
           manager.isScanning{
            manager.stopScan()
        }
    }

    public func connect(_ id: UUID) {
        NSLog("Connection attempt to: \(id)")
        if let peripheral = discoveredPeripherals[id]?.1 {
            if peripheral.state != .disconnected {
                NSLog("Already \(peripheral.state) to \(id). Skipping new connection attempt.")
                return
            }
            if let peripheralModel = model.peripherals.filter({ $0.identifier == peripheral.identifier }).first {
                // TODO: Remove model from model.peripherals and move it to connected peripherals
//                self.model.connectedPeripherals.append(peripheralModel)
                
                let controller = PeripheralController(peripheral: peripheral, model: peripheralModel)
                controller.recordPublisher.sink(receiveValue: { self.bluetoothPublisher.send($0) })
                    .store(in: &subscriptions)
                peripheral.delegate = controller
                peripheralControllers[id] = controller
                if let manager = self.manager {
                    manager.connect(peripheral, options: nil)
                }
            }
        }
    }

    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // Guidance for each state is documented at:
        // https://developer.apple.com/documentation/corebluetooth/cbmanagerstate
        switch central.state {
        // If the state is lower than powered off clear peripheral models.
        //  https://developer.apple.com/documentation/corebluetooth/cbcentralmanagerdelegate/1518888-centralmanagerdidupdatestate
        case CBManagerState.poweredOff:
            NSLog("CoreBluetooth state update: powered off")
//            model.state = "Powered off"
        case CBManagerState.poweredOn:
            NSLog("CoreBluetooth state update: powered on")
            // Start scanning for peripherals if requested and the manager state is now powered on.
            if isScanningRequested {
                if !central.isScanning {
                    central.scanForPeripherals(withServices: [CBUUID(string: "0x180d")], options: nil)
                }
            }
//            model.state = "Powered on"
        case CBManagerState.resetting:
            NSLog("CoreBluetooth state: resetting")
            invalidate()
//            model.state = "Resetting"
        case CBManagerState.unauthorized:
            NSLog("CoreBluetooth state: unauthorized")
            invalidate()
//            model.state = "Unauthorized"
        case CBManagerState.unknown:
            NSLog("CoreBluetooth state: unknown")
            invalidate()
//            model.state = "Unknown"
        case CBManagerState.unsupported:
            NSLog("CoreBluetooth state: unsupported")
            invalidate()
//            model.state = "Unsupported"
        default:
            // DEBUG
            fatalError("ERROR: Unknown enum value for CBManagerState in BluetoothController.centralManagerDidUpdateState")
        }
    }

//    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
//        NSLog("CoreBluetooth: Restoring central manager during relaunch into background")
//    }

    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if discoveredPeripherals[peripheral.identifier] == nil {
            discoveredPeripherals[peripheral.identifier] = (Date(), peripheral)
            self.model.peripherals.append(PeripheralModel(peripheral))
        }
    }

    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        NSLog("CoreBluetooth: connected to: \(peripheral.name ?? peripheral.identifier.uuidString)")
        self.didConnect.insert(peripheral.identifier)

        peripheral.discoverServices(nil)
    }
    
    // Removes members of the connectedPeripherals model property from the peripherals model property
    // Workaround to update the model after returning from the discovery view
    // Connecting on navigation and moving the model simultaneously is trouble
    public func filterConnectedPeripherals() {
        NSLog("filterConnectedPeripherals()")
        for id in self.didConnect {
            if let index = model.peripherals.firstIndex(where: { $0.identifier == id }) {
                model.connectedPeripherals.append(model.peripherals[index])
            }
        }

        model.peripherals.removeAll(where: { didConnect.contains($0.identifier) })
    }

    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        NSLog("CoreBluetooth: failed to connect to peripheral: \(peripheral.name ?? peripheral.identifier.uuidString)")
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        NSLog("CoreBluetooth: disconnected peripheral: \(peripheral.name ?? peripheral.identifier.uuidString)")
    }

    private func invalidate() {
        model.connectedPeripherals = []
        model.peripherals = []
        peripheralControllers = [:]
        discoveredPeripherals = [:]
        didConnect = Set<UUID>()
    }
}
