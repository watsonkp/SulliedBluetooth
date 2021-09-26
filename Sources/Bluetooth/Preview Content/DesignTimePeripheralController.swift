import CoreBluetooth

class DesignTimePeripheralController: PeripheralControllerProtocol {
    func notify(enabled: Bool, id: CBUUID) {
        NSLog("notify()")
        // TODO: Update notification property of the matching CharacteristicModel
    }
}
