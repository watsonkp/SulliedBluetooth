import CoreBluetooth

protocol BluetoothControllerProtocol {
    var model: BluetoothModel { get }
    var peripheralControllers: [UUID: PeripheralControllerProtocol] { get }
    func toggleScan() -> Void
    func connect(_ id: UUID) -> Void
    func filterConnectedPeripherals() -> Void
}

class BluetoothController: NSObject, CBCentralManagerDelegate, BluetoothControllerProtocol {
    private var manager: CBCentralManager
    var model: BluetoothModel = BluetoothModel()
    private let bluetoothBaseUUID = Data(base64Encoded: "AAAQAIAAAIBfmzT7")
    private let baseMemberUUID = Data(base64Encoded: "8AA=")!
    private var discoveredPeripherals = [UUID: (Date, CBPeripheral)]()
    var peripheralControllers = [UUID: PeripheralControllerProtocol]()

    override init() {
        // TODO: Consider moving this off of main thread
        // WARNING: Confusing XPC error at runtime if this isn't set during init
        manager = CBCentralManager(delegate: nil, queue: nil)
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

    func toggleScan() {
        if manager.isScanning {
            manager.stopScan()
            NSLog("BluetoothController: Stopped scanning")
        } else {
            self.manager.delegate = self
            if manager.state == CBManagerState.poweredOn {
//                manager.scanForPeripherals(withServices: nil, options: nil)
                // DEBUG: Filter to heart rate monitor for testing
                manager.scanForPeripherals(withServices: [CBUUID(string: "0x180d")], options: nil)
            }
        }
    }

    func connect(_ id: UUID) {
        NSLog("Connecting to: \(id)")

        if let peripheral = discoveredPeripherals[id]?.1 {
            if let peripheralModel = model.peripherals.filter({ $0.identifier == peripheral.identifier }).first {
                // TODO: Remove model from model.peripherals and move it to connected peripherals
//                self.model.connectedPeripherals.append(peripheralModel)
                
                let controller = PeripheralController(peripheral: peripheral, model: peripheralModel)
                peripheral.delegate = controller
                peripheralControllers[id] = controller
                manager.connect(peripheral, options: nil)
            }
        }
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // Guidance for each state is documented at:
        // https://developer.apple.com/documentation/corebluetooth/cbmanagerstate
        switch central.state {
        case CBManagerState.poweredOff:
            NSLog("CoreBluetooth state update: powered off")
//            model.state = "Powered off"
        case CBManagerState.poweredOn:
            NSLog("CoreBluetooth state update: powered on")
//            model.state = "Powered on"
        case CBManagerState.resetting:
            NSLog("CoreBluetooth state: resetting")
//            model.state = "Resetting"
        case CBManagerState.unauthorized:
            NSLog("CoreBluetooth state: unauthorized")
//            model.state = "Unauthorized"
        case CBManagerState.unknown:
            NSLog("CoreBluetooth state: unknown")
//            model.state = "Unknown"
        case CBManagerState.unsupported:
            NSLog("CoreBluetooth state: unsupported")
//            model.state = "Unsupported"
        default:
            // DEBUG
            fatalError("ERROR: Unknown enum value for CBManagerState in BluetoothController.centralManagerDidUpdateState")
        }
    }

//    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
//        NSLog("CoreBluetooth: Restoring central manager during relaunch into background")
//    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        NSLog("CoreBluetooth: Discovered a peripheral: \(peripheral.name ?? peripheral.identifier.uuidString)")
        if discoveredPeripherals[peripheral.identifier] == nil {
            discoveredPeripherals[peripheral.identifier] = (Date(), peripheral)
            self.model.peripherals.append(PeripheralModel(peripheral))
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        NSLog("CoreBluetooth: connected to: \(peripheral.name ?? peripheral.identifier.uuidString)")
        if let index = model.peripherals.firstIndex(where: { $0.identifier == peripheral.identifier }) {
            model.connectedPeripherals.append(model.peripherals[index])
        }

        peripheral.discoverServices(nil)
    }
    
    // Removes members of the connectedPeripherals model property from the peripherals model property
    // Workaround to update the model after returning from the discovery view
    // Connecting on navigation and moving the model simultaneously is trouble
    func filterConnectedPeripherals() {
        NSLog("filterConnectedPeripherals()")
        let connectedIDs = Set<UUID>(model.connectedPeripherals.map { $0.identifier })
        model.peripherals.removeAll(where: { connectedIDs.contains($0.identifier) })
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        NSLog("CoreBluetooth: failed to connect to peripheral: \(peripheral.name ?? peripheral.identifier.uuidString)")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        NSLog("CoreBluetooth: disconnected peripheral: \(peripheral.name ?? peripheral.identifier.uuidString)")
    }
}
