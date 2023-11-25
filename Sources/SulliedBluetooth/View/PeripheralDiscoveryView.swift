import SwiftUI
import CoreBluetooth

struct PeripheralDiscoveryView: View {
    var controller: PeripheralControllerProtocol?
    @ObservedObject var model: PeripheralModel

    var body: some View {
        ScrollView {
            Text("\(model.name ?? model.identifier.uuidString)")
                .font(.headline)
            ForEach(model.services, id: \ServiceModel.uuid) { service in
                ServiceView(model: service, notify: controller?.notify)
                Divider()
            }
        }
    }
}

struct PeripheralDiscoveryView_Previews: PreviewProvider {
    static var previews: some View {
        PeripheralDiscoveryView(controller: DesignTimePeripheralController(), model: DesignTimeModel.populatedPeripheral())
    }
}
