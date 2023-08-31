import XCTest
import CoreBluetooth
@testable import SulliedBluetooth

final class BluetoothTests: XCTestCase {
    func testHeartRateDecode() {
        let data = Data(base64Encoded: "EJ2HAYYBigE=")!
        let parsed = Bluetooth.decodeHeartRateMeasurement(value: data)
        XCTAssertEqual(parsed.heartRateMeasurementValue, 157)
        XCTAssertEqual(parsed.sensorContactSupported, false)
        XCTAssertEqual(parsed.sensorContactDetected, false)
        XCTAssertEqual(parsed.energyExpended, nil)
        XCTAssertEqual(parsed.rrInterval, [391, 390, 394])
    }
}
