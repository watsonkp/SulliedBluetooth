import SwiftUI

struct PeripheralView: View {
    @ObservedObject var model: PeripheralModel
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(model.name ?? "Unknown name")")
                    .font(.headline)
                Text("\(model.identifier)")
                    .font(.caption)
            }
            Spacer()
            if model.connectionState == .connecting {
                ProgressView()
            }
//            } else if let rssi = model.rssi {
//                if #available(iOS 16, *) {
//                    Gauge(value: Double(100 - max(0 - rssi, 0)) / 100.0, label: {
//                        Text("\(rssi) dB")
//                            .font(.caption)
//                    })
//                    .gaugeStyle(.accessoryCircularCapacity)
//                    .tint(.blue)
//                    .scaleEffect(0.67)
//                } else {
//                    Text("\(rssi) dB")
//                        .font(.caption)
//                }
//            }
        }
    }
}

struct PeripheralView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            PeripheralView(model: DesignTimeModel.populatedPeripheral())
            PeripheralView(model: PeripheralModel(identifier: UUID(),
                                                  name: "DEBUG",
                                                  state: .connecting))
            PeripheralView(model: PeripheralModel(identifier: UUID(),
                                                  name: nil,
                                                  state: .disconnected))
            PeripheralView(model: PeripheralModel(identifier: UUID(),
                                                  name: nil,
                                                  state: .disconnected))
        }
        .previewDisplayName("Portrait")

        List {
            PeripheralView(model: DesignTimeModel.populatedPeripheral())
            PeripheralView(model: PeripheralModel(identifier: UUID(),
                                                  name: "DEBUG",
                                                  state: .connecting))
            PeripheralView(model: PeripheralModel(identifier: UUID(),
                                                  name: nil,
                                                  state: .disconnected))
            PeripheralView(model: PeripheralModel(identifier: UUID(),
                                                  name: nil,
                                                  state: .disconnected))
        }

        .previewInterfaceOrientation(.landscapeRight)
        .previewDisplayName("Landscape")
        List {
            PeripheralView(model: DesignTimeModel.populatedPeripheral())
            PeripheralView(model: PeripheralModel(identifier: UUID(),
                                                  name: "DEBUG",
                                                  state: .connecting))
            PeripheralView(model: PeripheralModel(identifier: UUID(),
                                                  name: nil,
                                                  state: .disconnected))
            PeripheralView(model: PeripheralModel(identifier: UUID(),
                                                  name: nil,
                                                  state: .disconnected))
        }
        .previewDevice(PreviewDevice(rawValue: "iPhone SE (1st generation)"))
        .previewDisplayName("iPhone SE")

        List {
            PeripheralView(model: DesignTimeModel.populatedPeripheral())
            PeripheralView(model: PeripheralModel(identifier: UUID(),
                                                  name: "DEBUG",
                                                  state: .connecting))
            PeripheralView(model: PeripheralModel(identifier: UUID(),
                                                  name: nil,
                                                  state: .disconnected))
            PeripheralView(model: PeripheralModel(identifier: UUID(),
                                                  name: nil,
                                                  state: .disconnected))
        }
        .previewDevice(PreviewDevice(rawValue: "iPhone SE (1st generation)"))
        .previewDisplayName("iPhone SE - Landscape")
        .previewInterfaceOrientation(.landscapeRight)
    }
}
