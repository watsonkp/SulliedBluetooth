import SwiftUI
import CoreBluetooth

struct BluetoothServiceID: Identifiable {
    let id: Int
    let name: String
}

public struct ConnectionView: View {
    let controller: BluetoothControllerProtocol
    @ObservedObject
    var model: BluetoothModel

    @State var filteredServices = Set<UUID>()
    var serviceIDs = [BluetoothServiceID(id: 0x180d, name: "Heart Rate")]
    @State private var selectedPeripheral: UUID? = nil {
        willSet {
            if newValue != nil {
                controller.connect(newValue!)
            }
        }
    }
    
    @State var scanning: Bool = false

    public var body: some View {
        // View.onAppear() modifier on NavigationView doesn't work. It might be a bug in SwiftUI.
        NavigationView {
            List {
                Section {
                    ForEach(model.connectedPeripherals, id: \PeripheralModel.identifier) { peripheral in
                        NavigationLink(destination: PeripheralDiscoveryView(controller: controller.peripheralControllers[peripheral.identifier], model: peripheral),
                                       tag: peripheral.identifier,
                                       selection: Binding<UUID?>(get: { selectedPeripheral }, set: { selectedPeripheral = $0 }),
                                       label: {
                                        ConnectedPeripheralView(model: peripheral)})
                    }
                } header: {
                    Text("Connected")
                }
                Section {
                    ForEach(model.peripherals, id: \PeripheralModel.identifier) { peripheral in
                        NavigationLink(destination: PeripheralDiscoveryView(controller: controller.peripheralControllers[peripheral.identifier], model: peripheral),
                                       tag: peripheral.identifier,
                                       selection: Binding<UUID?>(get: { selectedPeripheral }, set: { selectedPeripheral = $0 }),
                                       label: {
                                        PeripheralView(model: peripheral)})
                    }
                } header: {
                    Text("Discovered")
                }.onAppear(perform: { controller.filterConnectedPeripherals() })
            }.navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        scanning = !scanning
                        controller.toggleScan()
                    }, label: {
                        Text("\(scanning ? "Stop" : "Scan")")
                            .font(.headline)
                    })
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                    }, label: {
                        Text("Filter")
                            .font(.headline)
                    })
                }
            }
        }
    }
}

struct ConnectionView_Previews: PreviewProvider {
    static let controller = DesignTimeBluetoothController()
    static var previews: some View {
        ConnectionView(controller: controller, model: controller.model)
    }
}
