import SwiftUI

struct ConnectedCharacteristicView: View {
    @ObservedObject var model: CharacteristicModel
    var body: some View {
        if let notifying = model.isNotifying {
            HStack {
                Text("\(model.name):").font(.caption)
                Text("\(notifying ? model.parsedValue.description : "Not recording")")
            }
        }
    }
}

struct ConnectedCharacteristicView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectedCharacteristicView(model: DesignTimeModel.populatedCharacteristic())
    }
}
