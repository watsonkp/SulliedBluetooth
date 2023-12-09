import CoreBluetooth
import Combine
import SulliedMeasurement

class DesignTimePeripheralController: PeripheralControllerProtocol {
    let model: PeripheralModel
    func notify(enabled: Bool, id: CBUUID) {
        for service in model.services {
            service.characteristics.first(where: { $0.uuid == id })?.isNotifying = enabled
        }
    }
    var recordPublisher = PassthroughSubject<IntegerDataPoint, Never>()
    private var subscriptions: [AnyCancellable] = []

    init(model: PeripheralModel) {
        self.model = model
        let start = Date.now

        // Publish heart rate characteristic values
        Timer.TimerPublisher(interval: 1.0, runLoop: .main, mode: .default).autoconnect()
            .map {
                let value = Int64($0.timeIntervalSince(start))
                return IntegerDataPoint(date: $0,
                                        unit: UnitFrequency.beatsPerMinute,
                                        usage: .heartRate,
                                        value: value,
                                        significantFigures: 3,
                                        significantPosition: 0)
            }
            .sink(receiveValue: { self.recordPublisher.send($0) })
            .store(in: &subscriptions)
//        Timer.TimerPublisher(interval: 1.0, runLoop: .main, mode: .default).autoconnect().map { _ in
//            Int64(model.services.first(where: { $0.uuid == CBUUID(string: "0x180d") })!.characteristics.first!.parsedValue.description)!
//        }.sink(receiveValue: {
//            self.recordPublisher.send(IntegerDataPoint(date: Date.now,
//                                                       unit: UnitFrequency.beatsPerMinute,
//                                                       usage: .heartRate,
//                                                       value: $0,
//                                                       significantFigures: 3,
//                                                       significantPosition: 0))
//        })

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
