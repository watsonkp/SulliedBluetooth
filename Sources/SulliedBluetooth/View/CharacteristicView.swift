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
        VStack(alignment: .leading) {
            if model.isAssignedNumber {
                if model.canRecord {
                    Toggle(model.name, isOn: Binding<Bool>(get: { model.isNotifying }, set: { notifying = $0 }))
                } else {
                    Text(model.name)
                }
                Text(model.parsedValue.description)
            } else {
                Text("Non-Standard Characteristic")
                Text(model.name)
                    .font(.caption)
            }
        }
    }
}

struct CharacteristicView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CharacteristicView(model: CharacteristicModel(uuid: CBUUID(string: "0x2a37"), properties: [.notify])) { _, _ in }
            CharacteristicView(model: CharacteristicModel(uuid: CBUUID(string: "6217FF4B-FB31-1140-AD5A-A45545D7ECF3"), properties: [])) { _, _ in }
        }
    }
}
