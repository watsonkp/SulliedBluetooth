import Foundation

// Gust Factor characteristic 0x2A74
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.gust_factor.yaml
public struct GustFactor {
    let gustFactor: UInt8
    public init?(from value: Data) {
        guard let factor = GustFactor.readUInt8(at: 0, of: value) else {
            return nil
        }
        gustFactor = factor
    }
}

extension GustFactor : CustomStringConvertible {
    public var description: String {
        get {
            "\(Decimal(gustFactor) / 10.0)"
        }
    }
}

extension GustFactor : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        get {
            ["Gust Factor" : String(describing: self)]
        }
    }
}
