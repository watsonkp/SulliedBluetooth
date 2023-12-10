import CoreBluetooth
import Combine
import SulliedMeasurement

public protocol PeripheralControllerProtocol {
    func notify(enabled: Bool, id: CBUUID) -> Void
}

class PeripheralController: NSObject, CBPeripheralDelegate, PeripheralControllerProtocol {
    var model: PeripheralModel
    private let peripheral: CBPeripheral
    private var characteristics = [CBUUID: CBCharacteristic]()
    var recordPublisher = PassthroughSubject<IntegerDataPoint, Never>()
    private var dateOffset: Double? = nil

    init(peripheral: CBPeripheral, model: PeripheralModel) {
        self.peripheral = peripheral
        self.model = model
        super.init()
    }
    
    func notify(enabled: Bool, id: CBUUID) {
        if let characteristic = characteristics[id] {
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
        if let error = error {
            model.errorMessage = "Error discovering Bluetooth characteristics for service \(service.uuid): \(error)"
            model.didFail = true
        }

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
        let timestamp = Date()
        // TODO: Publish the value
        if let serviceModel = model.services.filter({ $0.uuid == characteristic.service?.uuid }).first {
            if let characteristicModel = serviceModel.characteristics.filter({ $0.uuid == characteristic.uuid }).first {
                if characteristic.isNotifying {
                    characteristicModel.isNotifying = true
                }
                if characteristic.value != nil {
                    let record = BluetoothRecord(characteristic: characteristic, timestamp: timestamp)
                    switch (record.value) {
                    case .heartRateMeasurement(let measurement):
                        // Rapidly publishing a set of values (tested with 4) to a PassthroughSubject
                        //  will drop all but the first unless there is buffering.
                        recordPublisher.send(IntegerDataPoint(date: timestamp,
                                                              unit: UnitFrequency.beatsPerMinute,
                                                              usage: .heartRate,
                                                              value: Int64(measurement.heartRateMeasurementValue),
                                                              significantFigures: 3,
                                                              significantPosition: 0))
                        if let rrIntervals = measurement.rrInterval {
                            // TODO: Handle time intervals between characteristic updates that are larger than the cumulative reported RR-intervals.
                            //  Measurements could be missing. The heart rate measurement specification suggests that data will be dropped.
                            //  The assumption that no measurements are dropped will lead to skewed data.
                            // RR-interval measurements are sequential durations so time data needs to accumulate separately from the time the device received the data.
                            // The API aims to report time series data without requiring the receiver to use knowledge of Bluetooth.
                            // TODO: Guarantee that the date offset is unique to a characteristic and is reset.
                            // The initial date offset is set as the time of the first characteristic update less the measured durations.
                            var offset = dateOffset ?? rrIntervals.reduce(into: timestamp.timeIntervalSince1970) { $0 -= (Double($1) / 1024) }
                            for rrInterval in rrIntervals {
                                offset += (Double(rrInterval) / 1024)
                                recordPublisher.send(IntegerDataPoint(date: Date(timeIntervalSince1970: offset),
                                                                      unit: UnitDuration.milliseconds,
                                                                      usage: .rrInterval,
                                                                      value: Int64(Double(rrInterval) / 1024.0 * 1000.0),
                                                                      significantFigures: 4,
                                                                      significantPosition: 0))
                                dateOffset = offset
                            }
                        }
                    default:
                        // TODO: Error handling
                        break
                    }
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            model.errorMessage = "Error changing notification for Bluetooth characteristic \(characteristic.uuid): \(error)"
            model.didFail = true
        }

        if let serviceModel = model.services.filter({ $0.uuid == characteristic.service?.uuid }).first {
            if let characteristicModel = serviceModel.characteristics.filter({ $0.uuid == characteristic.uuid }).first {
                characteristicModel.isNotifying = characteristic.isNotifying
            }
        }
    }
}
