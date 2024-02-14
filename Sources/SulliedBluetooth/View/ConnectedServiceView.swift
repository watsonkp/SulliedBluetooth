import SwiftUI

struct ConnectedServiceView: View {
    @ObservedObject var model: ServiceModel
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(model.name)")
                .font(.subheadline)
            ForEach(model.characteristics, id: \CharacteristicModel.uuid) { characteristic in
                if !characteristic.fields.isEmpty || characteristic.canNotify {
                    ConnectedCharacteristicView(model: characteristic)
                }
            }
        }
    }
}

struct ConnectedServiceView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectedServiceView(model: DesignTimeModel.populatedService())
    }
}
