import SwiftUI
import CoreBluetooth

struct ServiceFilterView: View {
    @Environment(\.editMode) private var editMode
    @Binding var serviceFilter: Set<CBUUID>

    var body: some View {
        NavigationView {
            VStack {
                List(BluetoothRecord.supportedServices, id: \.id, selection: $serviceFilter) { service in
                    Label(String(describing: service), systemImage: "waveform")
                }
                .environment(\.editMode, self.editMode)
            }
            .toolbar{
                ToolbarItem {
                    Button(action: {
                        withAnimation {
                            if editMode?.wrappedValue == .active {
                                editMode?.wrappedValue = .inactive
                            } else {
                                editMode?.wrappedValue = .active
                            }
                        }
                    }) {
                        Text(editMode?.wrappedValue == .active ? "Single" : "Multiple")
                    }
                }
            }
            .navigationTitle("Peripherals with")
        }
    }
}

struct ServiceFilterView_Previews: PreviewProvider {
    static var previews: some View {
        @State var serviceFilter = Set<CBUUID>()
        ServiceFilterView(serviceFilter: $serviceFilter)
    }
}
