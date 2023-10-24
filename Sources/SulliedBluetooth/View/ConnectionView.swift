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
    @State var isEditingFilter: Bool = false
    @State private var serviceFilter = Set<CBUUID>()
//    @State private var selectedPeripheral: UUID? = nil {
//        willSet {
//            if newValue != nil {
//                controller.connect(newValue!)
//            }
//        }
//    }
    
    @State var scanning: Bool = false

    public init(controller: BluetoothControllerProtocol, model: BluetoothModel) {
        self.controller = controller
        self.model = model
    }

    public var body: some View {
        // View.onAppear() modifier on NavigationView doesn't work. It might be a bug in SwiftUI.
        NavigationView {
            List {
                Section {
                    ForEach(model.connectedPeripherals, id: \PeripheralModel.identifier) { peripheral in
                        NavigationLink(destination: PeripheralDiscoveryView(controller: controller.peripheralControllers[peripheral.identifier], model: peripheral),
//                                       tag: peripheral.identifier,
//                                       selection: Binding<UUID?>(get: { selectedPeripheral }, set: { selectedPeripheral = $0 }),
                                       label: {
                                        ConnectedPeripheralView(model: peripheral)})
                    }
                    .onDelete(perform: { indices in
                        withAnimation {
                            controller.disconnect(indices: indices)
                        }
                    })
                } header: {
                    Text("Connected")
                }
                Section {
                    ForEach(model.peripherals, id: \PeripheralModel.identifier) { peripheral in
                        Button(action: { controller.connect(peripheral.identifier) }) {
                            PeripheralView(model: peripheral)
                        }
//                        NavigationLink(destination: PeripheralDiscoveryView(controller: controller.peripheralControllers[peripheral.identifier], model: peripheral),
//                                       tag: peripheral.identifier,
//                                       selection: Binding<UUID?>(get: { selectedPeripheral }, set: { selectedPeripheral = $0 }),
//                                       label: {
//                                        PeripheralView(model: peripheral)})
                    }
                } header: {
                    Text("Discovered")
                }//.onAppear(perform: { controller.filterConnectedPeripherals() })
            }.navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if #available(iOS 15, *) {
                        Button(action: {
                            scanning = !scanning
                            controller.toggleScan(serviceFilter: serviceFilter)
                        }, label: {
                            Text("\(scanning ? "Stop" : "Scan")")
                                .font(.headline)
                        })
                        .buttonStyle(.borderedProminent)
                    } else {
                        Button(action: {
                            scanning = !scanning
                            controller.toggleScan(serviceFilter: serviceFilter)
                        }, label: {
                            Text("\(scanning ? "Stop" : "Scan")")
                                .font(.headline)
                        })
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    if #available(iOS 15, *) {
                        Button(role: .destructive, action: { controller.disconnectAll() }) {
                            Label("Disconnect All",
                                  systemImage: "xmark.circle")
                            .labelStyle(.titleAndIcon)
                        }
                        .buttonStyle(.bordered)
                    } else {
                        Button(action: { controller.disconnectAll() }) {
                            Label("Disconnect All",
                                  systemImage: "xmark.circle")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { self.isEditingFilter.toggle() }) {
                        Label("Filter", systemImage: "line.3.horizontal.decrease")
                    }.sheet(isPresented: $isEditingFilter) {
                        VStack {
                            ServiceFilterView(serviceFilter: $serviceFilter)
                            Button(action: { self.isEditingFilter.toggle() }) {
                                Text("Done")
                            }
                        }
                    }
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
