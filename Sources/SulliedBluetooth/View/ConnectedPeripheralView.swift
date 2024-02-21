import SwiftUI

struct ConnectedPeripheralView: View {
    @ObservedObject var model: PeripheralModel
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(model.name ?? "Unknown name")")
                .font(.headline)
            Text("\(model.identifier)")
                .font(.footnote)
                .minimumScaleFactor(0.5)
                .padding(.leading)
                .lineLimit(1)
            ForEach(model.services, id: \ServiceModel.uuid) { service in
                if service.isAssignedNumber {
                    Divider()
                    ConnectedServiceView(model: service)
                }
            }
        }
    }
}

struct ConnectedPeripheralView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectedPeripheralView(model: DesignTimeModel.populatedPeripheral())
    }
}
