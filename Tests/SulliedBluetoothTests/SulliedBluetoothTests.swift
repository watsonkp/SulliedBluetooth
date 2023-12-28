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

    // Test the cycling speed and cadence service
    func testCyclingSpeedAndCadence() {
        // Test the CSC Measurement characteristic of the service.
        let data = Data(base64Encoded: "AwAAAEAACABgASA=")
        var parsed = BluetoothRecord.decode(characteristic: CBUUID(string: "0x2A5B"), value: data)
        guard case .cyclingSpeedAndCadence(let parsedMeasurement) = parsed else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(parsedMeasurement.cumulativeWheelRevolutions, 64)
        XCTAssertEqual(parsedMeasurement.wheelEventTime, 8)
        XCTAssertEqual(parsedMeasurement.cumulativeCrankRevolutions, 96)
        XCTAssertEqual(parsedMeasurement.crankEventTime, 288)
        XCTAssertEqual(String(describing: parsedMeasurement), "Wheel(64, 8), Crank(96, 288)")

        let empty_data = Data(base64Encoded: "AA==")
        parsed = BluetoothRecord.decode(characteristic: CBUUID(string: "0x2A5B"), value: empty_data)
        guard case .cyclingSpeedAndCadence(let parsedMeasurement) = parsed else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(parsedMeasurement.cumulativeWheelRevolutions, nil)
        XCTAssertEqual(parsedMeasurement.wheelEventTime, nil)
        XCTAssertEqual(parsedMeasurement.cumulativeCrankRevolutions, nil)
        XCTAssertEqual(parsedMeasurement.crankEventTime, nil)
        XCTAssertEqual(String(describing: parsedMeasurement), "--")

        let wheel_data = Data(base64Encoded: "AQECAwQFBg==")
        parsed = BluetoothRecord.decode(characteristic: CBUUID(string: "0x2A5B"), value: wheel_data)
        guard case .cyclingSpeedAndCadence(let parsedMeasurement) = parsed else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(parsedMeasurement.cumulativeWheelRevolutions, 16909060)
        XCTAssertEqual(parsedMeasurement.wheelEventTime, 1286)
        XCTAssertEqual(parsedMeasurement.cumulativeCrankRevolutions, nil)
        XCTAssertEqual(parsedMeasurement.crankEventTime, nil)
        XCTAssertEqual(String(describing: parsedMeasurement), "Wheel(16909060, 1286)")

        let crank_data = Data(base64Encoded: "AgQDAgE=")
        parsed = BluetoothRecord.decode(characteristic: CBUUID(string: "0x2A5B"), value: crank_data)
        guard case .cyclingSpeedAndCadence(let parsedMeasurement) = parsed else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(parsedMeasurement.cumulativeWheelRevolutions, nil)
        XCTAssertEqual(parsedMeasurement.wheelEventTime, nil)
        XCTAssertEqual(parsedMeasurement.cumulativeCrankRevolutions, 1027)
        XCTAssertEqual(parsedMeasurement.crankEventTime, 513)
        XCTAssertEqual(String(describing: parsedMeasurement), "Crank(1027, 513)")
    }

    // Test the cycling power service
    func testCyclingPower() {
        // Test the Cycling Power Measurement characteristic of the service.
        let full_data = Data(base64Encoded: "/x8BAgMEBQYHCAkKCwwNDg8QERITFBUWFxgZGhscHR4fIA==")
        var parsed = BluetoothRecord.decode(characteristic: CBUUID(string: "0x2A63"), value: full_data)
        guard case .cyclingPower(let parsedMeasurement) = parsed else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(parsedMeasurement.instantaneousPower, 0x0102)
        XCTAssertEqual(parsedMeasurement.pedalPowerBalance, 0x03)
        XCTAssertEqual(parsedMeasurement.pedalPowerBalanceReference, .left)
        XCTAssertEqual(parsedMeasurement.accumulatedTorque, 0x0405)
        XCTAssertEqual(parsedMeasurement.accumulatedTorqueSource, .crank)
        XCTAssertEqual(parsedMeasurement.cumulativeWheelRevolutions, 0x06070809)
        XCTAssertEqual(parsedMeasurement.wheelEventTime, 0x0a0b)
        XCTAssertEqual(parsedMeasurement.cumulativeCrankRevolutions, 0x0c0d)
        XCTAssertEqual(parsedMeasurement.crankEventTime, 0x0e0f)
        XCTAssertEqual(parsedMeasurement.maximumForceMagnitude, 0x1011)
        XCTAssertEqual(parsedMeasurement.minimumForceMagnitude, 0x1213)
        XCTAssertEqual(parsedMeasurement.maximumTorqueMagnitude, 0x1415)
        XCTAssertEqual(parsedMeasurement.minimumTorqueMagnitude, 0x1617)
        XCTAssertEqual(parsedMeasurement.maximumAngle, 0x0181)
        XCTAssertEqual(parsedMeasurement.minimumAngle, 0x91a)
        XCTAssertEqual(parsedMeasurement.topDeadSpotAngle, 0x1b1c)
        XCTAssertEqual(parsedMeasurement.bottomDeadSpotAngle, 0x1d1e)
        XCTAssertEqual(parsedMeasurement.accumulatedEnergy, 0x1f20)
        XCTAssertEqual(parsedMeasurement.offsetCompensationIndicator, true)

        let minimal_data = Data(base64Encoded: "AAAD6A==")
        parsed = BluetoothRecord.decode(characteristic: CBUUID(string: "0x2A63"), value: minimal_data)
        guard case .cyclingPower(let parsedMeasurement) = parsed else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(parsedMeasurement.instantaneousPower, 1000)
        XCTAssertEqual(parsedMeasurement.pedalPowerBalance, nil)
        XCTAssertEqual(parsedMeasurement.pedalPowerBalanceReference, .unknown)
        XCTAssertEqual(parsedMeasurement.accumulatedTorque, nil)
        XCTAssertEqual(parsedMeasurement.accumulatedTorqueSource, .wheel)
        XCTAssertEqual(parsedMeasurement.cumulativeWheelRevolutions, nil)
        XCTAssertEqual(parsedMeasurement.wheelEventTime, nil)
        XCTAssertEqual(parsedMeasurement.cumulativeCrankRevolutions, nil)
        XCTAssertEqual(parsedMeasurement.crankEventTime, nil)
        XCTAssertEqual(parsedMeasurement.maximumForceMagnitude, nil)
        XCTAssertEqual(parsedMeasurement.minimumForceMagnitude, nil)
        XCTAssertEqual(parsedMeasurement.maximumTorqueMagnitude, nil)
        XCTAssertEqual(parsedMeasurement.minimumTorqueMagnitude, nil)
        XCTAssertEqual(parsedMeasurement.maximumAngle, nil)
        XCTAssertEqual(parsedMeasurement.minimumAngle, nil)
        XCTAssertEqual(parsedMeasurement.topDeadSpotAngle, nil)
        XCTAssertEqual(parsedMeasurement.bottomDeadSpotAngle, nil)
        XCTAssertEqual(parsedMeasurement.accumulatedEnergy, nil)
        XCTAssertEqual(parsedMeasurement.offsetCompensationIndicator, false)
    }

    func testDesignTimeModel() {
        var data = Data(count: 2)
        data[1] = UInt8(170 + 10  * sin(12 * Double.pi / 8))
        let value = ValueModel(id: CBUUID(string: "0x2a37"), value: data)
        XCTAssertEqual("160", String(describing: value))
    }
}
