import Foundation
import CoreBluetooth

public struct Bluetooth {
    private static let bluetoothBaseUUID = Array<UInt8>([0x00, 0x00, 0x10, 0x00, 0x80, 0x00, 0x00, 0x80, 0x5f, 0x9b, 0x34, 0xfb])
        .withUnsafeBufferPointer({ Data(buffer: $0) })
    private static let baseMemberUUID = Array<UInt8>([0xf0, 0x00])
        .withUnsafeBufferPointer({ Data(buffer: $0) })
    static func isAssignedNumber(_ id: CBUUID) -> Bool {
        // Companies can request 16 bit IDs. They are all above 0xF000.
        if id.data.count == 2 && id.data[0] >= Bluetooth.baseMemberUUID[0] {
            return false
        }
        // Pre-allocated UUIDs are shifted left 96 bits and added to the Bluetooth base UUID of 00000000-0000-1000-8000-00805F9B34FB
        // Bluetooth Core specification 5.3 Part B Section 2.5.1 page 1181
        if (id.data.count == 2) || (id.data.count == 4) || ((id.data.count == 16) && (Bluetooth.bluetoothBaseUUID == id.data[4 ..< 16])) {
            return true
        } else {
            return false
        }
    }

    static func readUInt32(at i: Int, of data: Data) -> UInt32? {
        guard i + 3 < data.count else {
            return nil
        }
        return UInt32(data[i]) | UInt32(data[i+1])<<8 | UInt32(data[i+2])<<16 | UInt32(data[i+3])<<24
    }

    static func readString(at i: Int, of data: Data) -> String {
        return String(unsafeUninitializedCapacity: data.count) {
            _ = $0.initialize(from: data)
            return data.count
        }
    }
}
