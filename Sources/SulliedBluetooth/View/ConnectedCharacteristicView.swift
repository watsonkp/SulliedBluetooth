import SwiftUI

struct ConnectedCharacteristicView: View {
    @ObservedObject var model: CharacteristicModel
    var body: some View {
        HStack {
            Text("\(model.name):")
                .lineLimit(1)
            Text(String(describing: model.parsedValue))
            if model.canNotify {
                Image(systemName: model.isNotifying ? "stop.circle" : "record.circle")
            }
        }
    }
}

struct ConnectedCharacteristicView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectedCharacteristicView(model: DesignTimeModel.populatedCharacteristic())
    }
}
