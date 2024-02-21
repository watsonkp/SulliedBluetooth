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
            } else if let rssi = model.rssi {
                Text("\(rssi)")
            }
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
                                                  state: .disconnected,
                                                  rssi: 42))
        }
    }
}
