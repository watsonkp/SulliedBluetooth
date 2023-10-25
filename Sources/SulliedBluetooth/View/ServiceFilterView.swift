import SwiftUI
import CoreBluetooth

struct ServiceFilterView: View {
    @State private var editMode = EditMode.inactive
    @Binding var serviceFilter: Set<CBUUID>

    var body: some View {
        NavigationView {
            VStack {
                List(BluetoothRecord.supportedServices, id: \.id, selection: $serviceFilter) { service in
                    Label(String(describing: service), systemImage: "waveform")
                }
                .environment(\.editMode, $editMode)
            }
            .toolbar{
                ToolbarItem {
                    Button(action: {
                        withAnimation {
                            editMode = editMode == .active ? .inactive : .active
                        }
                    }) {
                        Text(editMode == .inactive ? "Single" : "Multiple")
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
