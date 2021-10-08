import SwiftUI

struct ConnectedPeripheralView: View {
    @ObservedObject var model: PeripheralModel
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(model.name ?? "???")")
            Text("\(model.identifier)").font(.footnote)
            ForEach(model.services, id: \ServiceModel.uuid) { service in
                ConnectedServiceView(model: service)
            }
        }
    }
}

struct ConnectedPeripheralView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectedPeripheralView(model: DesignTimeModel.populatedPeripheral())
    }
}
