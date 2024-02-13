import Foundation

public struct CyclingPowerFeature: OptionSet {
    public let rawValue: UInt32

    static let pedalPowerBalanceSupported = CyclingPowerFeature(rawValue: 1 << 0)
    static let accumulatedTorqueSupported = CyclingPowerFeature(rawValue: 1 << 1)
    static let wheelRevolutionDataSupported = CyclingPowerFeature(rawValue: 1 << 2)
    static let crankRevolutionDataSupported = CyclingPowerFeature(rawValue: 1 << 3)
    static let extremeMagnitudesSupported = CyclingPowerFeature(rawValue: 1 << 4)
    static let extremeAnglesSupported = CyclingPowerFeature(rawValue: 1 << 5)
    static let topAndBottomDeadSpotAnglesSupported = CyclingPowerFeature(rawValue: 1 << 6)
    static let accumulatedEnergySupported = CyclingPowerFeature(rawValue: 1 << 7)
    static let offsetCompensationIndicatorSupported = CyclingPowerFeature(rawValue: 1 << 8)
    static let offsetCompensationSupported = CyclingPowerFeature(rawValue: 1 << 9)
    static let cyclingPowerMeasurementCharacteristicContentMaskingSupported = CyclingPowerFeature(rawValue: 1 << 10)
    static let multipleSensorLocationsSupported = CyclingPowerFeature(rawValue: 1 << 11)
    static let crankLengthAdjustmentSupported = CyclingPowerFeature(rawValue: 1 << 12)
    static let chainLengthAdjustmentSupported = CyclingPowerFeature(rawValue: 1 << 13)
    static let chainWeightAdjustmentSupported = CyclingPowerFeature(rawValue: 1 << 14)
    static let spanLengthAdjustmentSupported = CyclingPowerFeature(rawValue: 1 << 15)
    static let sensorMeasurementContext = CyclingPowerFeature(rawValue: 1 << 16)
    static let instantaneousMeasurementDirectionSupported = CyclingPowerFeature(rawValue: 1 << 17)
    static let factoryCalibrationDateSupported = CyclingPowerFeature(rawValue: 1 << 18)
    static let enhancedOffsetCompensationProcedureSupported = CyclingPowerFeature(rawValue: 1 << 19)
    static let distributedSystemSupportNotForUse = CyclingPowerFeature(rawValue: 1 << 20)
    static let distributedSystemSupportForUse = CyclingPowerFeature(rawValue: 1 << 21)

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
}

extension CyclingPowerFeature: CustomStringConvertible {
    public var description: String {
        get {
            fieldDescriptions.map { key, value in key }.joined(separator: ", ")
        }
    }
}

extension CyclingPowerFeature {
    public var fieldDescriptions: [String : String] {
        get {
            var featureDescriptions: [String : String] = [:]
            if self.contains(.pedalPowerBalanceSupported) {
                featureDescriptions["Pedal Power Balance"] = "Supported"
            }
            if self.contains(.accumulatedTorqueSupported) {
                featureDescriptions["Accumulated Torque"] = "Supported"
            }
            if self.contains(.wheelRevolutionDataSupported) {
                featureDescriptions["Wheel Revolution Data"] = "Supported"
            }
            if self.contains(.crankRevolutionDataSupported) {
                featureDescriptions["Crank Revolution Data"] = "Supported"
            }
            if self.contains(.extremeMagnitudesSupported) {
                featureDescriptions["Extreme Magnitudes"] = "Supported"
            }
            if self.contains(.extremeAnglesSupported) {
                featureDescriptions["Extreme Angles"] = "Supported"
            }
            if self.contains(.topAndBottomDeadSpotAnglesSupported) {
                featureDescriptions["Top and Bottom Dead Spot Angles"] = "Supported"
            }
            if self.contains(.accumulatedEnergySupported) {
                featureDescriptions["Accumulated Energy"] = "Supported"
            }
            if self.contains(.offsetCompensationIndicatorSupported) {
                featureDescriptions["Offset Compensation Indicator"] = "Supported"
            }
            if self.contains(.offsetCompensationSupported) {
                featureDescriptions["Offset Compensation"] = "Supported"
            }
            if self.contains(.cyclingPowerMeasurementCharacteristicContentMaskingSupported) {
                featureDescriptions["Cycling Power Measurement Characteristic Content Masking"] = "Supported"
            }
            if self.contains(.multipleSensorLocationsSupported) {
                featureDescriptions["Multiple Sensor Locations"] = "Supported"
            }
            if self.contains(.crankLengthAdjustmentSupported) {
                featureDescriptions["Crank Length Adjustment"] = "Supported"
            }
            if self.contains(.chainLengthAdjustmentSupported) {
                featureDescriptions["Chain Length Adjustment"] = "Supported"
            }
            if self.contains(.chainWeightAdjustmentSupported) {
                featureDescriptions["Chain Weight Adjustment"] = "Supported"
            }
            if self.contains(.spanLengthAdjustmentSupported) {
                featureDescriptions["Span Length Adjustment"] = "Supported"
            }
            if self.contains(.sensorMeasurementContext) {
                featureDescriptions["Sensor Measurement Context"] = "Supported"
            }
            if self.contains(.instantaneousMeasurementDirectionSupported) {
                featureDescriptions["Instantaneous Measurement Direction"] = "Supported"
            }
            if self.contains(.factoryCalibrationDateSupported) {
                featureDescriptions["Factory Calibration Date"] = "Supported"
            }
            if self.contains(.enhancedOffsetCompensationProcedureSupported) {
                featureDescriptions["Enhanced Offset Compensation Procedure"] = "Supported"
            }
            if self.contains(.distributedSystemSupportNotForUse) && self.contains(.distributedSystemSupportForUse) {
                featureDescriptions["Distributed System Support"] = "Unrecognized distributeed system support value"
            } else if self.contains(.distributedSystemSupportNotForUse) {
                featureDescriptions["Distributed System Support"] = "Not for use in a distributed system"
            } else if self.contains(.distributedSystemSupportForUse) {
                featureDescriptions["Distributed System Support"] = "For use in a distributed system"
            } else {
                featureDescriptions["Distributed System Support"] = "Distributed system support unspecified (legacy sensor)"
            }
            return featureDescriptions
        }
    }
}
