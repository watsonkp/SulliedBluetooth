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
                        .font(.headline)
                } else {
                    Text(model.name)
                        .font(.headline)
                }
                ForEach(model.fields) { field in
                    VStack(alignment: .leading) {
                        Text(field.fieldDescription)
                            .font(.caption)
                        Text(field.valueDescription)
                    }
                }
            } else {
                Text("Non-Standard Characteristic")
                    .font(.headline)
                Text(model.name)
            }
        }
    }
}

struct CharacteristicView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CharacteristicView(model: CharacteristicModel(uuid: CBUUID(string: "0x2a37"), properties: [.notify], value: [0x18, 0xa0, 0x80, 0x04, 0x00, 0x04, 0x00, 0x03].withUnsafeBufferPointer({ Data($0) }))) { _, _ in }
            CharacteristicView(model: CharacteristicModel(uuid: CBUUID(string: "0x2a63"), properties: [.notify], value: [0x30, 0x00, 0x10, 0x01, 0xAB, 0xAD, 0x1D, 0xEA, 0x00, 0x0a, 0x00, 0x10, 0x00, 0x03].withUnsafeBufferPointer({ Data($0) }))) { _, _ in }
            CharacteristicView(model: CharacteristicModel(uuid: CBUUID(string: "6217FF4B-FB31-1140-AD5A-A45545D7ECF3"), properties: [])) { _, _ in }
        }
    }
}
