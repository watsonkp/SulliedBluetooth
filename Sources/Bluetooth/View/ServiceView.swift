import SwiftUI
import CoreBluetooth

struct ServiceView: View {
    @ObservedObject var model: ServiceModel
    var notify: ((Bool, CBUUID) -> ())?

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(model.name)")
            ForEach(model.characteristics, id: \CharacteristicModel.uuid) { characteristic in
                CharacteristicView(model: characteristic, notify: notify)
            }
        }.padding()
    }
}

struct ServiceView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceView(model: DesignTimeModel.populatedService()) { enabled, id in
            // TODO: notify
        }
    }
}
