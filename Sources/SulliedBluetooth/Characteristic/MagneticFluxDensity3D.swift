import Foundation

// Magnetic Flux Density 3D 0x2AA1
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.magnetic_flux_density_-_3d.yaml
public struct MagneticFluxDensity3D {
    let xAxis: Int16
    let yAxis: Int16
    let zAxis: Int16

    public init?(from value: Data) {
        guard let x = MagneticFluxDensity2D.readInt16(at: 0, of: value),
              let y = MagneticFluxDensity2D.readInt16(at: 2, of: value),
              let z = MagneticFluxDensity2D.readInt16(at: 4, of: value) else {
            return nil
        }
        xAxis = x
        yAxis = y
        zAxis = z
    }
}

extension MagneticFluxDensity3D : CustomStringConvertible {
    public var description: String {
        get {
            "\(Decimal(xAxis) / 10000000) T, \(Decimal(yAxis) / 10000000) T, , \(Decimal(zAxis) / 10000000) T"
        }
    }
}

extension MagneticFluxDensity3D : DecodedCharacteristic {
    var fieldDescriptions: [String : String] {
        get {
            [
                "x": "\(Decimal(xAxis) / 10000000) T",
                "y": "\(Decimal(yAxis) / 10000000) T",
                "z": "\(Decimal(zAxis) / 10000000) T",
            ]
        }
    }
}
