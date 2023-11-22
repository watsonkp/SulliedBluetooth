import SwiftUI

struct PeripheralView: View {
    @ObservedObject var model: PeripheralModel
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(model.name ?? "???")")
                    .font(.headline)
                Text("\(model.identifier)")
                    .font(.caption)
            }
            if model.connectionState == .connecting {
                Spacer()
                ProgressView()
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
        }
    }
}
