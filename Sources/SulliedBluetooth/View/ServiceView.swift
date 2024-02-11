import SwiftUI
import CoreBluetooth

struct ServiceView: View {
    @ObservedObject var model: ServiceModel
    var notify: ((Bool, CBUUID) -> ())?

    var body: some View {
        Section {
            ForEach(model.characteristics, id: \CharacteristicModel.uuid) { characteristic in
                CharacteristicView(model: characteristic, notify: notify)
            }
        } header: {
            if model.isAssignedNumber {
                Text("\(model.name) Service")
            } else {
                Text("Non-Standard Service")
            }
        } footer: {
            if !model.isAssignedNumber {
                Text(model.uuid.uuidString)
            }
        }
    }
}

struct ServiceView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ServiceView(model: DesignTimeModel.populatedService()) { _, _ in }
        }
    }
}
