import SwiftUI

struct PeripheralView: View {
    let model: PeripheralModel
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(model.name ?? "???")")
            Text("\(model.identifier)").font(.footnote)
        }
    }
}

struct PeripheralView_Previews: PreviewProvider {
    static var previews: some View {
        PeripheralView(model: DesignTimeModel.populatedPeripheral())
    }
}
