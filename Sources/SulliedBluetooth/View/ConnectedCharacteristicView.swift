import SwiftUI

struct ConnectedCharacteristicView: View {
    @ObservedObject var model: CharacteristicModel
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if model.isAssignedNumber {
                    Text("\(model.name)")
                        .lineLimit(1)
                        .font(.caption)
                    ForEach(model.fields) { field in
                        if field.fieldDescription != model.name {
                            Text(field.fieldDescription)
                                .font(.caption2)
                        }
                        Text(field.valueDescription)
                    }
                    if model.fields.isEmpty && model.canNotify {
                        Text("Not recording")
                    }
                } else {
                    Text("Non-Standard Characteristic")
                        .lineLimit(1)
                        .font(.caption)
                    Text(model.name)
                        .font(.caption2)
                }
            }
            Spacer()
            if model.canNotify && model.isAssignedNumber {
                Image(systemName: model.isNotifying ? "stop.circle" : "record.circle")
                    .foregroundColor(.accentColor)
            }
        }
    }
}

struct ConnectedCharacteristicView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectedCharacteristicView(model: DesignTimeModel.populatedCharacteristic())
    }
}
