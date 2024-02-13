import Foundation
import CoreBluetooth

public struct FieldModel {
    let characteristicID: CBUUID
    let fieldDescription: String
    let valueDescription: String
}

extension FieldModel: Equatable {
    public static func == (lhs: FieldModel, rhs: FieldModel) -> Bool {
        return lhs.characteristicID == rhs.characteristicID
        && lhs.fieldDescription == rhs.fieldDescription
    }
}

extension FieldModel: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(characteristicID)
        hasher.combine(fieldDescription)
    }
}

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
            "\(fieldDescription): \(valueDescription)"
        }
    }
}
