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
