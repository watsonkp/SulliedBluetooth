import SwiftUI

struct UUIDView: View {
    let id: UUID

    var body: some View {
        Text("\(id.uuidString)")
            .accessibilityRepresentation {
                VStack {
                    Text("ID starts with \(String(id.uuidString.prefix(4)))")
                    Text("ID ends with \(String(id.uuidString.suffix(4)))")
                    Text("Full \(id.uuidString.count) digit ID is \(id.uuidString)")
                }
            }
    }
}

// TODO: Update build system to support Preview
//#Preview {
//    UUIDView(id: UUID())
//}
