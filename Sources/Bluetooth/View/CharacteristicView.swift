import SwiftUI
import CoreBluetooth

struct CharacteristicView: View {
    @ObservedObject var model: CharacteristicModel
    var notify: ((Bool, CBUUID) -> ())?
    @State var notifying: Bool = false {
        willSet {
            if let notify = notify {
                notify(newValue, model.uuid)
            }
        }
    }
    var body: some View {
        HStack {
            Text("\(model.name):").font(.caption)
            Text(model.parsedValue.description)
            if model.properties.contains(.notify) {
                Text("n")
                Toggle("", isOn: Binding<Bool>(get: { notifying }, set: { notifying = $0 }))
            }
            Spacer()
        }
    }
}

struct CharacteristicView_Previews: PreviewProvider {
    static var previews: some View {
        CharacteristicView(model: CharacteristicModel(uuid: CBUUID(string: "0x2a37"), properties: [.notify])) { enabled, id in
            // TODO: notify
        }
    }
}
