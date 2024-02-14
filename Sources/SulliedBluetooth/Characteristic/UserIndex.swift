import Foundation

public struct UserIndex {
    let userIndex: UInt8
}

extension UserIndex: CustomStringConvertible {
    public var description: String {
        get {
            userIndex < 255 ? "\(userIndex)" : "Unknown"
        }
    }
}

extension UserIndex : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        get {
            userIndex != 255 ? ["User Index" : "\(userIndex)"] : [:]
        }
    }
}
