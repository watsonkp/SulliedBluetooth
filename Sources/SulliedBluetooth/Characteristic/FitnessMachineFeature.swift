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

extension FitnessMachineFeature {
    public var fieldDescriptions: [String] {
        get {
            fitnessMachineFeatures.featureDescriptions + targetSettingFeatures.featureDescriptions
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
            featureDescriptions.joined(separator: ", ")
        }
    }
}

extension FitnessMachineFeatures {
    public var featureDescriptions: [String] {
        get {
            var featureDescriptions: [String] = []

            if self.contains(.averageSpeedSupported) {
                featureDescriptions.append("Average Speed")
            }
            if self.contains(.cadenceSupported) {
                featureDescriptions.append("Cadence")
            }
            if self.contains(.totalDistanceSupported) {
                featureDescriptions.append("Total Distance")
            }
            if self.contains(.inclinationSupported) {
                featureDescriptions.append("Inclination")
            }
            if self.contains(.elevationGainSupported) {
                featureDescriptions.append("Elevation Gain")
            }
            if self.contains(.paceSupported) {
                featureDescriptions.append("Pace")
            }
            if self.contains(.stepCountSupported) {
                featureDescriptions.append("Step Count")
            }
            if self.contains(.resistanceLevelSupported) {
                featureDescriptions.append("Resistance Level")
            }
            if self.contains(.strideCountSupported) {
                featureDescriptions.append("Stride Count")
            }
            if self.contains(.expendedEnergySupported) {
                featureDescriptions.append("Expended Energy")
            }
            if self.contains(.heartRateMeasurementSupported) {
                featureDescriptions.append("Heart Rate Measurement")
            }
            if self.contains(.metabolicEquivalentSupported) {
                featureDescriptions.append("Metabolic Equivalent")
            }
            if self.contains(.elapsedTimeSupported) {
                featureDescriptions.append("Elapsed Time")
            }
            if self.contains(.remainingTimeSupported) {
                featureDescriptions.append("Remaining Time")
            }
            if self.contains(.powerMeasurementSupported) {
                featureDescriptions.append("Power Measurement")
            }
            if self.contains(.forceonBeltandPowerOutputSupported) {
                featureDescriptions.append("Force on Belt and Power Output")
            }
            if self.contains(.userDataRetentionSupported) {
                featureDescriptions.append("User Data Retention")
            }

            return featureDescriptions
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
            featureDescriptions.joined(separator: ", ")
        }
    }
}

extension TargetSettingFeatures {
    public var featureDescriptions: [String] {
        get {
            var featureDescriptions: [String] = []

            if self.contains(.speedTargetSettingSupported) {
                featureDescriptions.append("Speed Target Setting")
            }
            if self.contains(.inclinationTargetSettingSupported) {
                featureDescriptions.append("Inclination Target Setting")
            }
            if self.contains(.resistanceTargetSettingSupported) {
                featureDescriptions.append("Resistance Target Setting")
            }
            if self.contains(.powerTargetSettingSupported) {
                featureDescriptions.append("Power Target Setting")
            }
            if self.contains(.heartRateTargetSettingSupported) {
                featureDescriptions.append("Heart Rate Target Setting")
            }
            if self.contains(.targetedExpendedEnergyConfigurationSupported) {
                featureDescriptions.append("Targeted Expended Energy Configuration")
            }
            if self.contains(.targetedStepNumberConfigurationSupported) {
                featureDescriptions.append("Targeted Step Number Configuration")
            }
            if self.contains(.targetedStrideNumberConfigurationSupported) {
                featureDescriptions.append("Targeted Stride Number Configuration")
            }
            if self.contains(.targetedDistanceConfigurationSupported) {
                featureDescriptions.append("Targeted Distance Configuration")
            }
            if self.contains(.targetedTrainingTimeConfigurationSupported) {
                featureDescriptions.append("Targeted Training Time Configuration")
            }
            if self.contains(.targetedTimeinTwoHeartRateZonesConfigurationSupported) {
                featureDescriptions.append("Targeted Time in Two Heart Rate Zones Configuration")
            }
            if self.contains(.targetedTimeinThreeHeartRateZonesConfigurationSupported) {
                featureDescriptions.append("Targeted Time in Three Heart Rate Zones Configuration")
            }
            if self.contains(.targetedTimeinFiveHeartRateZonesConfigurationSupported) {
                featureDescriptions.append("Targeted Time in Five Heart Rate Zones Configuration")
            }
            if self.contains(.indoorBikeSimulationParametersSupported) {
                featureDescriptions.append("Indoor Bike Simulation Parameters")
            }
            if self.contains(.wheelCircumferenceConfigurationSupported) {
                featureDescriptions.append("Wheel Circumference Configuration")
            }
            if self.contains(.spinDownControlSupported) {
                featureDescriptions.append("Spin Down Control")
            }
            if self.contains(.targetedCadenceConfigurationSupported) {
                featureDescriptions.append("Targeted Cadence Configuration")
            }

            return featureDescriptions
        }
    }
}
