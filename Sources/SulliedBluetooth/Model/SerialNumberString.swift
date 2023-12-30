import Foundation

// Serial Number String characteristic
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.serial_number_string.yaml
public struct SerialNumberString: DecodedCharacteristic {
    let serialNumber: String

    init(value: Data) {
        serialNumber = SerialNumberString.readString(at: 0, of: value)
    }
}

extension SerialNumberString: CustomStringConvertible {
    public var description: String {
        get {
            serialNumber
        }
    }
}
