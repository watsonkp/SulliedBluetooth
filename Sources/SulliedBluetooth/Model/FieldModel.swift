import Foundation
import CoreBluetooth

public struct FieldModel {
    let characteristicID: CBUUID
    let valueDescription: String
}

extension FieldModel: Hashable { }

extension FieldModel: Identifiable {
    public var id: Self {
        get {
            self
        }
    }
}

extension FieldModel: CustomStringConvertible {
    public var description: String {
        get {
            valueDescription
        }
    }
}
