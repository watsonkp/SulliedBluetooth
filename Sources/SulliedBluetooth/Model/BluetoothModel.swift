import CoreBluetooth

public class BluetoothModel: ObservableObject {
    @Published var peripherals = [PeripheralModel]()
    @Published var connectedPeripherals = [PeripheralModel]()
    @Published var didFail = false
    @Published var errorMessage = ""

    public var isReceivingNotifications: Bool {
        get {
            for peripheral in connectedPeripherals {
                for service in peripheral.services {
                    for characteristic in service.characteristics {
                        return characteristic.isNotifying
                    }
                }
            }
            return false
        }
    }
}
