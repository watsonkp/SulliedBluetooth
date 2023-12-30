import Foundation

// Model Number characteristic
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.model_number_string.yaml
public struct ModelNumber: DecodedCharacteristic {
    let modelNumber: String

    init(value: Data) {
        modelNumber = ModelNumber.readString(at: 0, of: value)
    }
}

extension ModelNumber: CustomStringConvertible {
    public var description: String {
        get {
            modelNumber
        }
    }
}
