import Foundation

// UV Index characteristic 0x2A76
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.uv_index.yaml
public struct UVIndex {
    let uvIndex: UInt8

    public init?(from value: Data) {
        guard let index = UVIndex.readUInt8(at: 0, of: value) else {
            return nil
        }
        uvIndex = index
    }
}

extension UVIndex : CustomStringConvertible {
    public var description: String {
        get {
            "\(uvIndex)"
        }
    }
}

extension UVIndex : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        get {
            ["UV Index": String(describing: self)]
        }
    }
}
