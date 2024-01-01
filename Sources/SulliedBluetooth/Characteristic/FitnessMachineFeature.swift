import Foundation

public struct FitnessMachineFeature: DecodedCharacteristic {
   let fitnessMachineFeatures: FitnessMachineFeatures
   let targetSettingFeatures: TargetSettingFeatures

    public init?(value: Data) {
        guard value.count == 8,
              let fitnessMachine = FitnessMachineFeature.readUInt32(at: 0, of: value),
              let targetSetting = FitnessMachineFeature.readUInt32(at: 4, of: value) else {
            return nil
        }
        fitnessMachineFeatures = FitnessMachineFeatures(rawValue: fitnessMachine)
        targetSettingFeatures = TargetSettingFeatures(rawValue: targetSetting)
   }
}

extension FitnessMachineFeature: CustomStringConvertible {
    public var description: String {
        get {
            String(describing: fitnessMachineFeatures) + "\n" + String(describing: targetSettingFeatures)
        }
    }
}

public struct FitnessMachineFeatures: OptionSet {
    public let rawValue: UInt32

    static let averageSpeedSupported = FitnessMachineFeatures(rawValue: 1 << 0)
    static let cadenceSupported = FitnessMachineFeatures(rawValue: 1 << 1)
    static let totalDistanceSupported = FitnessMachineFeatures(rawValue: 1 << 2)
    static let inclinationSupported = FitnessMachineFeatures(rawValue: 1 << 3)
    static let elevationGainSupported = FitnessMachineFeatures(rawValue: 1 << 4)
    static let paceSupported = FitnessMachineFeatures(rawValue: 1 << 5)
    static let stepCountSupported = FitnessMachineFeatures(rawValue: 1 << 6)
    static let resistanceLevelSupported = FitnessMachineFeatures(rawValue: 1 << 7)
    static let strideCountSupported = FitnessMachineFeatures(rawValue: 1 << 8)
    static let expendedEnergySupported = FitnessMachineFeatures(rawValue: 1 << 9)
    static let heartRateMeasurementSupported = FitnessMachineFeatures(rawValue: 1 << 10)
    static let metabolicEquivalentSupported = FitnessMachineFeatures(rawValue: 1 << 11)
    static let elapsedTimeSupported = FitnessMachineFeatures(rawValue: 1 << 12)
    static let remainingTimeSupported = FitnessMachineFeatures(rawValue: 1 << 13)
    static let powerMeasurementSupported = FitnessMachineFeatures(rawValue: 1 << 14)
    static let forceonBeltandPowerOutputSupported = FitnessMachineFeatures(rawValue: 1 << 15)
    static let userDataRetentionSupported = FitnessMachineFeatures(rawValue: 1 << 16)

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
}

extension FitnessMachineFeatures: CustomStringConvertible {
    public var description: String {
        get {
            var featureDescription = ""
            if self.contains(.averageSpeedSupported) {
                featureDescription += "Average Speed, "
            }
            if self.contains(.cadenceSupported) {
                featureDescription += "Cadence, "
            }
            if self.contains(.totalDistanceSupported) {
                featureDescription += "Total Distance, "
            }
            if self.contains(.inclinationSupported) {
                featureDescription += "Inclination, "
            }
            if self.contains(.elevationGainSupported) {
                featureDescription += "Elevation Gain, "
            }
            if self.contains(.paceSupported) {
                featureDescription += "Pace, "
            }
            if self.contains(.stepCountSupported) {
                featureDescription += "Step Count, "
            }
            if self.contains(.resistanceLevelSupported) {
                featureDescription += "Resistance Level, "
            }
            if self.contains(.strideCountSupported) {
                featureDescription += "Stride Count, "
            }
            if self.contains(.expendedEnergySupported) {
                featureDescription += "Expended Energy, "
            }
            if self.contains(.heartRateMeasurementSupported) {
                featureDescription += "Heart Rate Measurement, "
            }
            if self.contains(.metabolicEquivalentSupported) {
                featureDescription += "Metabolic Equivalent, "
            }
            if self.contains(.elapsedTimeSupported) {
                featureDescription += "Elapsed Time, "
            }
            if self.contains(.remainingTimeSupported) {
                featureDescription += "Remaining Time, "
            }
            if self.contains(.powerMeasurementSupported) {
                featureDescription += "Power Measurement, "
            }
            if self.contains(.forceonBeltandPowerOutputSupported) {
                featureDescription += "Force on Belt and Power Output, "
            }
            if self.contains(.userDataRetentionSupported) {
                featureDescription += "User Data Retention, "
            }
            return String(featureDescription.prefix(upTo: featureDescription.lastIndex(of: ",") ?? featureDescription.startIndex))
        }
    }
}

public struct TargetSettingFeatures: OptionSet {
    public let rawValue: UInt32

    static let speedTargetSettingSupported = TargetSettingFeatures(rawValue: 1 << 0)
    static let inclinationTargetSettingSupported = TargetSettingFeatures(rawValue: 1 << 1)
    static let resistanceTargetSettingSupported = TargetSettingFeatures(rawValue: 1 << 2)
    static let powerTargetSettingSupported = TargetSettingFeatures(rawValue: 1 << 3)
    static let heartRateTargetSettingSupported = TargetSettingFeatures(rawValue: 1 << 4)
    static let targetedExpendedEnergyConfigurationSupported = TargetSettingFeatures(rawValue: 1 << 5)
    static let targetedStepNumberConfigurationSupported = TargetSettingFeatures(rawValue: 1 << 6)
    static let targetedStrideNumberConfigurationSupported = TargetSettingFeatures(rawValue: 1 << 7)
    static let targetedDistanceConfigurationSupported = TargetSettingFeatures(rawValue: 1 << 8)
    static let targetedTrainingTimeConfigurationSupported = TargetSettingFeatures(rawValue: 1 << 9)
    static let targetedTimeinTwoHeartRateZonesConfigurationSupported = TargetSettingFeatures(rawValue: 1 << 10)
    static let targetedTimeinThreeHeartRateZonesConfigurationSupported = TargetSettingFeatures(rawValue: 1 << 11)
    static let targetedTimeinFiveHeartRateZonesConfigurationSupported = TargetSettingFeatures(rawValue: 1 << 12)
    static let indoorBikeSimulationParametersSupported = TargetSettingFeatures(rawValue: 1 << 13)
    static let wheelCircumferenceConfigurationSupported = TargetSettingFeatures(rawValue: 1 << 14)
    static let spinDownControlSupported = TargetSettingFeatures(rawValue: 1 << 15)
    static let targetedCadenceConfigurationSupported = TargetSettingFeatures(rawValue: 1 << 16)

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
}

extension TargetSettingFeatures: CustomStringConvertible {
    public var description: String {
        get {
            var featureDescription = ""
            if self.contains(.speedTargetSettingSupported) {
                featureDescription += "Speed Target Setting, "
            }
            if self.contains(.inclinationTargetSettingSupported) {
                featureDescription += "Inclination Target Setting, "
            }
            if self.contains(.resistanceTargetSettingSupported) {
                featureDescription += "Resistance Target Setting, "
            }
            if self.contains(.powerTargetSettingSupported) {
                featureDescription += "Power Target Setting, "
            }
            if self.contains(.heartRateTargetSettingSupported) {
                featureDescription += "Heart Rate Target Setting, "
            }
            if self.contains(.targetedExpendedEnergyConfigurationSupported) {
                featureDescription += "Targeted Expended Energy Configuration, "
            }
            if self.contains(.targetedStepNumberConfigurationSupported) {
                featureDescription += "Targeted Step Number Configuration, "
            }
            if self.contains(.targetedStrideNumberConfigurationSupported) {
                featureDescription += "Targeted Stride Number Configuration, "
            }
            if self.contains(.targetedDistanceConfigurationSupported) {
                featureDescription += "Targeted Distance Configuration, "
            }
            if self.contains(.targetedTrainingTimeConfigurationSupported) {
                featureDescription += "Targeted Training Time Configuration, "
            }
            if self.contains(.targetedTimeinTwoHeartRateZonesConfigurationSupported) {
                featureDescription += "Targeted Time in Two Heart Rate Zones Configuration, "
            }
            if self.contains(.targetedTimeinThreeHeartRateZonesConfigurationSupported) {
                featureDescription += "Targeted Time in Three Heart Rate Zones Configuration, "
            }
            if self.contains(.targetedTimeinFiveHeartRateZonesConfigurationSupported) {
                featureDescription += "Targeted Time in Five Heart Rate Zones Configuration, "
            }
            if self.contains(.indoorBikeSimulationParametersSupported) {
                featureDescription += "Indoor Bike Simulation Parameters, "
            }
            if self.contains(.wheelCircumferenceConfigurationSupported) {
                featureDescription += "Wheel Circumference Configuration, "
            }
            if self.contains(.spinDownControlSupported) {
                featureDescription += "Spin Down Control, "
            }
            if self.contains(.targetedCadenceConfigurationSupported) {
                featureDescription += "Targeted Cadence Configuration, "
            }

            return String(featureDescription.prefix(upTo: featureDescription.lastIndex(of: ",") ?? featureDescription.startIndex))
        }
    }
}
