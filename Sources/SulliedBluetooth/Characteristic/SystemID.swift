import Foundation

// System ID characteristic
//  https://bitbucket.org/bluetooth-SIG/public/src/main/gss/org.bluetooth.characteristic.system_id.yaml
public struct SystemID: DecodedCharacteristic {
    let organizationallyUniqueIdentifier: UInt32
    let manufacturerDefinedIdentifier: UInt32

    init?(value: Data) {
        guard value.count == 8,
              let oui = SystemID.readUInt32(at: 0, of: value),
              let mdi = SystemID.readUInt32(at: 4, of: value) else {
            return nil
        }

        organizationallyUniqueIdentifier = oui
        manufacturerDefinedIdentifier = mdi
//        var typedValue = [UInt8](repeating:0, count: value.count)
//        typedValue.withUnsafeMutableBytes({(bs: UnsafeMutableRawBufferPointer) -> Void in
//            value.copyBytes(to: bs, count: value.count)
//        })

//        let secondField = typedValue.suffix(from: 5)
//        var oui: UInt64 = 0
//        for i in secondField.startIndex ..< secondField.endIndex {
//            oui += UInt64(secondField[i]) << (8 * (i-secondField.startIndex))
//        }

        // If System ID is based on a Bluetooth Device Address
//        if (typedValue[3] == 0xfe) && (typedValue[4] == 0xff) {
//            let field = typedValue.prefix(3)
//            var cai: UInt64 = 0
//            for i in field.startIndex ..< field.endIndex {
//                cai += UInt64(field[i]) << (8 * i)
//            }
//            return String(format: "CAI: %X, OUI: %X", cai, oui)
//        }

//        let firstField = typedValue.prefix(5)
//        var lso: UInt64 = 0
//        for i in firstField.startIndex ..< firstField.endIndex {
//            lso += UInt64(firstField[i]) << (8 * i)
//        }
//        return String(format: "MI:%lX, OUI: %X", lso, oui)
    }
}

extension SystemID: CustomStringConvertible {
    public var description: String {
        get {
            return String(format: "OUI: %X, MDI: %X", organizationallyUniqueIdentifier, manufacturerDefinedIdentifier)
        }
    }
}

extension SystemID {
    public var fieldDescriptions: [String : String] {
        get {
            [
                "Organizationally Unique Identifier" : String(format: "%X", organizationallyUniqueIdentifier),
                "Manufacturer Defined Identifier" : String(format: "%X", manufacturerDefinedIdentifier)
            ]
        }
    }
}
