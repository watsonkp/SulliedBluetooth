import CoreBluetooth
import Combine

public protocol PeripheralControllerProtocol {
    func notify(enabled: Bool, id: CBUUID) -> Void
}

class PeripheralController: NSObject, CBPeripheralDelegate, PeripheralControllerProtocol {
    var model: PeripheralModel
    private let peripheral: CBPeripheral
    private var characteristics = [CBUUID: CBCharacteristic]()
    var recordPublisher = PassthroughSubject<DataPoint, Never>()

    init(peripheral: CBPeripheral, model: PeripheralModel) {
        self.peripheral = peripheral
        self.model = model
        super.init()
    }
    
    func notify(enabled: Bool, id: CBUUID) {
        if let characteristic = characteristics[id] {
            NSLog("CoreBluetooth: notify for \(characteristic.uuid) set to \(enabled)")
            self.peripheral.setNotifyValue(enabled, for: characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        // TODO: Check for error
        if let services = peripheral.services {
            for service in services {
                model.services.append(ServiceModel(service))
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        NSLog("CoreBluetooth: Discovered characteristics for service \(service.uuid)")

        if let serviceModel = model.services.filter({ $0.uuid == service.uuid }).first {
            if let characteristics = service.characteristics {
                for characteristic in characteristics {
                    self.characteristics[characteristic.uuid] = characteristic
                    let characteristicModel = CharacteristicModel(characteristic)
                    if characteristic.properties.contains(.notify) {
                        characteristicModel.isNotifying = characteristic.isNotifying
                    }
                    serviceModel.characteristics.append(characteristicModel)
                    if characteristic.properties.contains(.read) {
                        peripheral.readValue(for: characteristic)
                    }
                }
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        NSLog("CoreBluetooth: didUpdateValueFor \(characteristic.uuid)")
        let timestamp = Date()
        // TODO: Publish the value
        if let serviceModel = model.services.filter({ $0.uuid == characteristic.service?.uuid }).first {
            if let characteristicModel = serviceModel.characteristics.filter({ $0.uuid == characteristic.uuid }).first {
                characteristicModel.value = characteristic.value?.base64EncodedString()
                if characteristic.isNotifying {
                    characteristicModel.isNotifying = true
                }
                if characteristic.value != nil {
                    let record = BluetoothRecord(characteristic: characteristic, timestamp: timestamp)
                    switch (record.value) {
                    case .heartRateMeasurement(let measurement):
                        // Rapidly publishing a set of values (typically 4) to a PassthroughSubject
                        //  will drop all but the first unless there is buffering.
                        recordPublisher.send(DataPoint(date: timestamp,
                                                       unit: 193,
                                                       value: Int64(measurement.heartRateMeasurementValue)))
                        if let rrIntervals = measurement.rrInterval {
                            for rrInterval in rrIntervals {
                                // TODO: Timestamps should be cumulative RR-interval value.
                                //  Drop values that arrive out of order?
                                //  Sending duplicate time stamps as is.
                                recordPublisher.send(DataPoint(date: timestamp,
                                                               unit: 194,
                                                               value: Int64(rrInterval)))
                            }
                        }
                    default:
                        // TODO: Something
                        break
                    }
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            NSLog("CoreBluetooth: ERROR didUpdateNotificationStateFor \(error)")
        }
        NSLog("CoreBluetooth: didUpdateNotificationStateFor \(characteristic.uuid) to \(characteristic.isNotifying)")
        if let serviceModel = model.services.filter({ $0.uuid == characteristic.service?.uuid }).first {
            if let characteristicModel = serviceModel.characteristics.filter({ $0.uuid == characteristic.uuid }).first {
                characteristicModel.isNotifying = characteristic.isNotifying
                NSLog("Update isNotifying of characteristicModel")
            }
        }
    }
}
