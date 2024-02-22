import Foundation

// Heat Index characteristic 0x2A7A
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.heat_index.yaml
public struct HeatIndex {
    let heatIndex: Int8
    public init?(from value: Data) {
        guard let temperature = HeatIndex.readInt8(at: 0, of: value) else {
            return nil
        }
        heatIndex = temperature
    }
}

extension HeatIndex : CustomStringConvertible {
    public var description: String {
        get {
            Measurement(value: Double(heatIndex),
                        unit: UnitTemperature.celsius)
            .formatted()
        }
    }
}

extension HeatIndex : DecodedCharacteristic {
    public var fieldDescriptions: [String : String] {
        get {
            ["Heat Index" : String(describing: self)]
        }
    }
}
