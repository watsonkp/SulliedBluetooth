import Foundation
import CoreBluetooth

struct SupportedService: Identifiable, Hashable, CustomStringConvertible {
    let id: CBUUID
    let description: String
}
