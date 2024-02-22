import Foundation

// Magnetic Flux Density 2D characteristic 0x2AA0
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.magnetic_flux_density_-_2d.yaml
public struct MagneticFluxDensity2D {
    let xAxis: Int16
    let yAxis: Int16
    public init?(from value: Data) {
        guard let x = MagneticFluxDensity2D.readInt16(at: 0, of: value),
              let y = MagneticFluxDensity2D.readInt16(at: 2, of: value) else {
            return nil
        }
        xAxis = x
        yAxis = y
    }
}

extension MagneticFluxDensity2D : CustomStringConvertible {
    public var description: String {
        get {
            "\(Decimal(xAxis) / 10000000) T, \(Decimal(yAxis) / 10000000) T"
        }
    }
}

extension MagneticFluxDensity2D : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        get {
            [
                "x": "\(Decimal(xAxis) / 10000000) T",
                "y": "\(Decimal(yAxis) / 10000000) T",
            ]
        }
    }
}
