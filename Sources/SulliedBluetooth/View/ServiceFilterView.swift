import SwiftUI
import CoreBluetooth

struct ServiceFilterView: View {
    // WARNING: iPhone SE on iOS 15 does not have a functioning single selection for .inactive.
    @State private var editMode = EditMode.active
    @Binding var serviceFilter: Set<CBUUID>

    var body: some View {
        NavigationView {
            VStack {
                List(BluetoothRecord.supportedServices, id: \.id, selection: $serviceFilter) { service in
                    Label(String(describing: service), systemImage: "waveform")
                }
                .environment(\.editMode, $editMode)
            }
            .navigationTitle("Services")
        }
    }
}

struct ServiceFilterView_Previews: PreviewProvider {
    static var previews: some View {
        @State var serviceFilter = Set<CBUUID>()
        ServiceFilterView(serviceFilter: $serviceFilter)
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        ServiceFilterView(serviceFilter: $serviceFilter)
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (1st generation)"))
            .previewDisplayName("iPhone SE")
    }
}
