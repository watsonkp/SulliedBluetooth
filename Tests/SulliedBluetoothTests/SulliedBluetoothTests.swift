import XCTest
import CoreBluetooth
@testable import SulliedBluetooth

final class BluetoothTests: XCTestCase {
    func testHeartRateDecode() {
        let data0 = Data(base64Encoded: "EJ2HAYYBigE=")!
        let parsed0 = Bluetooth.decodeHeartRateMeasurement(value: data0)
        XCTAssertEqual(parsed0.heartRateMeasurementValue, 157)
        XCTAssertEqual(parsed0.sensorContactSupported, false)
        XCTAssertEqual(parsed0.sensorContactDetected, false)
        XCTAssertEqual(parsed0.energyExpended, nil)
        XCTAssertEqual(parsed0.rrInterval, [391, 390, 394])

        let data1 = Data(base64Encoded: "EJOeAaEBogE=")!
        let parsed1 = Bluetooth.decodeHeartRateMeasurement(value: data1)
        XCTAssertEqual(parsed1.heartRateMeasurementValue, 147)
        XCTAssertEqual(parsed1.sensorContactSupported, false)
        XCTAssertEqual(parsed1.sensorContactDetected, false)
        XCTAssertEqual(parsed1.energyExpended, nil)
        XCTAssertEqual(parsed1.rrInterval, [414, 417, 418])

        let data2 = Data(base64Encoded: "EK5fAV8BXwE=")!
        let parsed2 = Bluetooth.decodeHeartRateMeasurement(value: data2)
        XCTAssertEqual(parsed2.heartRateMeasurementValue, 174)
        XCTAssertEqual(parsed2.sensorContactSupported, false)
        XCTAssertEqual(parsed2.sensorContactDetected, false)
        XCTAssertEqual(parsed2.energyExpended, nil)
        XCTAssertEqual(parsed2.rrInterval, [351, 351, 351])
    }

    func testDesignTimeModel() {
        var data = Data(count: 2)
        data[1] = UInt8(170 + 10  * sin(12 * Double.pi / 8))
        let value = ValueModel(id: CBUUID(string: "0x2a37"), value: data)
        XCTAssertEqual("160", String(describing: value))
    }
}
