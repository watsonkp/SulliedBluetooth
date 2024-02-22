import Foundation

// Irradiance characteristic 0x2A77
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.irradiance.yaml
public struct Irradiance {
    let irradiance: UInt16
    public init?(from value: Data) {
        guard let fluxConcentration = Irradiance.readUInt16(at: 0, of: value) else {
            return nil
        }
        irradiance = fluxConcentration
    }
}

extension Irradiance : CustomStringConvertible {
    public var description: String {
        get {
            "\(Decimal(irradiance) / 10.0) W/m²"
        }
    }
}

extension Irradiance : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        get {
            ["Irradiance" : String(describing: self)]
        }
    }
}
