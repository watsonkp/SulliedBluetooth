import SwiftUI
import CoreBluetooth

struct PeripheralDiscoveryView: View {
    var controller: PeripheralControllerProtocol?
    @ObservedObject var model: PeripheralModel

    var body: some View {
        List {
            ForEach(model.services, id: \ServiceModel.uuid) { service in
                ServiceView(model: service, notify: controller?.notify)
            }
        }
        .navigationTitle(model.name ?? model.identifier.uuidString)
    }
}

struct PeripheralDiscoveryView_Previews: PreviewProvider {
    static var previews: some View {
        let peripheral = DesignTimeModel.populatedPeripheral()
        NavigationView {
            PeripheralDiscoveryView(controller: DesignTimePeripheralController(model: peripheral),
                                    model: peripheral)
        }
    }
}
