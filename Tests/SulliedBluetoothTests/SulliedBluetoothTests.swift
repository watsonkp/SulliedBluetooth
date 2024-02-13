import XCTest
import CoreBluetooth
@testable import SulliedBluetooth

final class BluetoothTests: XCTestCase {
    func testUUID() {
        // Service UUIDs
        XCTAssertTrue(Bluetooth.isAssignedNumber(CBUUID(string: "0x1818")))
        XCTAssertTrue(Bluetooth.isAssignedNumber(CBUUID(string: "0x00001818-0000-1000-8000-00805F9B34FB")))
        // Polar H10
        XCTAssertFalse(Bluetooth.isAssignedNumber(CBUUID(string: "6217FF4B-FB31-1140-AD5A-A45545D7ECF3")))
        XCTAssertFalse(Bluetooth.isAssignedNumber(CBUUID(string: "FB005C80-02E7-F387-1CAD-8ACD2D8DF0C8")))
        XCTAssertFalse(Bluetooth.isAssignedNumber(CBUUID(string: "FEEE")))
        // Tacx Flux
        XCTAssertFalse(Bluetooth.isAssignedNumber(CBUUID(string: "669AA501-0C08-969E-E211-86AD5062675F")))
        XCTAssertFalse(Bluetooth.isAssignedNumber(CBUUID(string: "669AA605-0C08-969E-E211-86AD5062675F")))
        XCTAssertFalse(Bluetooth.isAssignedNumber(CBUUID(string: "6E40FEC1-B5A3-F393-E0A9-E50E24DCCA9E")))

        // Characteristic UUIDs
        XCTAssertTrue(Bluetooth.isAssignedNumber(CBUUID(string: "0x2A5B")))
        // Polar H10
        XCTAssertFalse(Bluetooth.isAssignedNumber(CBUUID(string: "6217FF4C-C8EC-B1FB-1380-3AD986708E2D")))
        XCTAssertFalse(Bluetooth.isAssignedNumber(CBUUID(string: "6217FF4D-91BB-91D0-7E2A-7CD3BDA8A1F3")))
        XCTAssertFalse(Bluetooth.isAssignedNumber(CBUUID(string: "FB005C51-02E7-F387-1CAD-8ACD2D8DF0C8")))
        XCTAssertFalse(Bluetooth.isAssignedNumber(CBUUID(string: "FB005C52-02E7-F387-1CAD-8ACD2D8DF0C8")))
        XCTAssertFalse(Bluetooth.isAssignedNumber(CBUUID(string: "FB005C53-02E7-F387-1CAD-8ACD2D8DF0C8")))
        XCTAssertFalse(Bluetooth.isAssignedNumber(CBUUID(string: "FB005C81-02E7-F387-1CAD-8ACD2D8DF0C8")))
        XCTAssertFalse(Bluetooth.isAssignedNumber(CBUUID(string: "FB005C82-02E7-F387-1CAD-8ACD2D8DF0C8")))
        // Tacx Flux
        XCTAssertFalse(Bluetooth.isAssignedNumber(CBUUID(string: "669AAB01-0C08-969E-E211-86AD5062675F")))
        XCTAssertFalse(Bluetooth.isAssignedNumber(CBUUID(string: "669AAB02-0C08-969E-E211-86AD5062675F")))
        XCTAssertFalse(Bluetooth.isAssignedNumber(CBUUID(string: "669AAB21-0C08-969E-E211-86AD5062675F")))
        XCTAssertFalse(Bluetooth.isAssignedNumber(CBUUID(string: "669AAB22-0C08-969E-E211-86AD5062675F")))
        XCTAssertFalse(Bluetooth.isAssignedNumber(CBUUID(string: "669AAC01-0C08-969E-E211-86AD5062675F")))
        XCTAssertFalse(Bluetooth.isAssignedNumber(CBUUID(string: "6E40FEC2-B5A3-F393-E0A9-E50E24DCCA9E")))
        XCTAssertFalse(Bluetooth.isAssignedNumber(CBUUID(string: "6E40FEC3-B5A3-F393-E0A9-E50E24DCCA9E")))
    }

    func testHeartRateCharacteristic() {
        let characteristic = CharacteristicModel(uuid: CBUUID(string: "0x2a37"),
                                                 properties: [.notify],
                                                 value: [0x10, 0xa0, 0x00, 0x04, 0x00, 0x03].withUnsafeBufferPointer({ Data($0) }))
        XCTAssertEqual(characteristic.fields[0].description, "160 bpm")
        XCTAssertEqual(characteristic.fields[1].description, "1.024 secs., 0.768 secs.")

        let characteristic16Bit = CharacteristicModel(uuid: CBUUID(string: "0x2a37"),
                                                 properties: [.notify],
                                                 value: [0x11, 0x05, 0x01, 0x00, 0x04, 0x00, 0x03].withUnsafeBufferPointer({ Data($0) }))
        XCTAssertEqual(characteristic16Bit.fields[0].description, "261 bpm")
        XCTAssertEqual(characteristic16Bit.fields[1].description, "1.024 secs., 0.768 secs.")

        let characteristicEnergy = CharacteristicModel(uuid: CBUUID(string: "0x2a37"),
                                                       properties: [.notify],
                                                       value: [0x08, 0xa0, 0x80, 0x04].withUnsafeBufferPointer({ Data($0) }))
        XCTAssertEqual(characteristicEnergy.fields[0].description, "160 bpm")
        XCTAssertEqual(characteristicEnergy.fields[1].description, "275 Calories")
    }

    func testCyclingPowerCharacteristic() {
        let characteristic = CharacteristicModel(uuid: CBUUID(string: "0x2a63"),
                                                 properties: [.notify],
                                                 value: [0x30, 0x00, 0x10, 0x01, 0xAB, 0xAD, 0x1D, 0xEA,
                                                         0x00, 0x0a, 0x00, 0x10, 0x00, 0x03].withUnsafeBufferPointer({ Data($0) }))
        XCTAssertEqual(characteristic.fields[0].description, "272 W")
        XCTAssertEqual(characteristic.fields[1].description, "3,927,813,547 revolutions")
        XCTAssertEqual(characteristic.fields[2].description, "1.25 seconds")
        XCTAssertEqual(characteristic.fields[3].description, "4,096 revolutions")
        XCTAssertEqual(characteristic.fields[4].description, "0.75 seconds")
    }

    // Test the cycling speed and cadence service
    func testCyclingSpeedAndCadence() {
        // Test the CSC Measurement characteristic of the service.
        let data = Data(base64Encoded: "AwAAAEAACABgASA=")
        var parsed = Bluetooth.decode(characteristic: CBUUID(string: "0x2A5B"), from: data)
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
        parsed = Bluetooth.decode(characteristic: CBUUID(string: "0x2A5B"), from: empty_data)
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
        parsed = Bluetooth.decode(characteristic: CBUUID(string: "0x2A5B"), from: wheel_data)
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
        parsed = Bluetooth.decode(characteristic: CBUUID(string: "0x2A5B"), from: crank_data)
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
        var parsed = Bluetooth.decode(characteristic: CBUUID(string: "0x2A63"), from: full_data)
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
        parsed = Bluetooth.decode(characteristic: CBUUID(string: "0x2A63"), from: minimal_data)
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
