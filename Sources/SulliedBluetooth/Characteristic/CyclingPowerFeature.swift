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
            var featureDescription = ""
            if self.contains(.pedalPowerBalanceSupported) {
                featureDescription += "Pedal Power Balance, "
            }
            if self.contains(.accumulatedTorqueSupported) {
                featureDescription += "Accumulated Torque, "
            }
            if self.contains(.wheelRevolutionDataSupported) {
                featureDescription += "Wheel Revolution Data, "
            }
            if self.contains(.crankRevolutionDataSupported) {
                featureDescription += "Crank Revolution Data, "
            }
            if self.contains(.extremeMagnitudesSupported) {
                featureDescription += "Extreme Magnitudes, "
            }
            if self.contains(.extremeAnglesSupported) {
                featureDescription += "Extreme Angles, "
            }
            if self.contains(.topAndBottomDeadSpotAnglesSupported) {
                featureDescription += "Top and Bottom Dead Spot Angles, "
            }
            if self.contains(.accumulatedEnergySupported) {
                featureDescription += "Accumulated Energy, "
            }
            if self.contains(.offsetCompensationIndicatorSupported) {
                featureDescription += "Offset Compensation Indicator, "
            }
            if self.contains(.offsetCompensationSupported) {
                featureDescription += "Offset Compensation, "
            }
            if self.contains(.cyclingPowerMeasurementCharacteristicContentMaskingSupported) {
                featureDescription += "Cycling Power Measurement Characteristic Content Masking, "
            }
            if self.contains(.multipleSensorLocationsSupported) {
                featureDescription += "Multiple Sensor Locations, "
            }
            if self.contains(.crankLengthAdjustmentSupported) {
                featureDescription += "Crank Length Adjustment, "
            }
            if self.contains(.chainLengthAdjustmentSupported) {
                featureDescription += "Chain Length Adjustment, "
            }
            if self.contains(.chainWeightAdjustmentSupported) {
                featureDescription += "Chain Weight Adjustment, "
            }
            if self.contains(.spanLengthAdjustmentSupported) {
                featureDescription += "Span Length Adjustment, "
            }
            if self.contains(.sensorMeasurementContext) {
                featureDescription += "Sensor Measurement Context, "
            }
            if self.contains(.instantaneousMeasurementDirectionSupported) {
                featureDescription += "Instantaneous Measurement Direction, "
            }
            if self.contains(.factoryCalibrationDateSupported) {
                featureDescription += "Factory Calibration Date, "
            }
            if self.contains(.enhancedOffsetCompensationProcedureSupported) {
                featureDescription += "Enhanced Offset Compensation Procedure, "
            }
            if self.contains(.distributedSystemSupportNotForUse) && self.contains(.distributedSystemSupportForUse) {
                featureDescription += "Unrecognized distributeed system support value, "
            } else if self.contains(.distributedSystemSupportNotForUse) {
                featureDescription += "Not for use in a distributed system, "
            } else if self.contains(.distributedSystemSupportForUse) {
                featureDescription += "For use in a distributed system, "
            } else {
                featureDescription += "Distributed system support unspecified (legacy sensor), "
            }

            return featureDescription
        }
    }
}
