import CoreBluetooth
import Combine
import SulliedMeasurement

class DesignTimePeripheralController: PeripheralControllerProtocol {
    // TODO: This is wrong.
    var isNotifying: Bool = true
    let model: PeripheralModel
    func notify(enabled: Bool, id: CBUUID) {
        for service in model.services {
            service.characteristics.first(where: { $0.uuid == id })?.isNotifying = enabled
        }
    }
//    var recordPublisher = PassthroughSubject<IntegerDataPoint, Never>()
    var recordPublisher = PassthroughSubject<BluetoothRecord, Never>()
    private var subscriptions: [AnyCancellable] = []

    init(model: PeripheralModel) {
        self.model = model
        let start = Date.now

        // Publish heart rate characteristic values
//        Timer.TimerPublisher(interval: 1.0, runLoop: .main, mode: .default).autoconnect()
//            .compactMap {
//                guard let value = self.model.services.first(where: { $0.uuid == CBUUID(string: "0x180d") })?
//                    .characteristics.filter({ $0.isNotifying }).first?
//                    .parsedValue.description,
//                let measurement = Int64(value) else {
//                    return nil
//                }
//                return IntegerDataPoint(date: $0,
//                                        unit: UnitFrequency.beatsPerMinute,
//                                        usage: .heartRate,
//                                        value: measurement,
//                                        significantFigures: 3,
//                                        significantPosition: 0)
//            }
//            .sink(receiveValue: { self.recordPublisher.send($0) })
//            .store(in: &subscriptions)

        // Update heart rate characteristic values
        Timer.TimerPublisher(interval: 1.0, runLoop: .main, mode: .default).autoconnect().map { _ in
            var data = Data(count: 2)
            data[1] = 123
            data[1] = UInt8(170 + 10 * sin(Date.now.timeIntervalSince(start) * Double.pi / 8))
            return data
        }
        .assign(to: &model.services.first(where: { $0.uuid == CBUUID(string: "0x180d") })!.characteristics.first!.$value)
    }
}
