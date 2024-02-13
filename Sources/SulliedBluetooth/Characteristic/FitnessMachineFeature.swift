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
    public var fieldDescriptions: [String : String] {
        get {
            [
                "Fitness Machine Features" : String(describing: fitnessMachineFeatures),
                "Target Setting Features" : String(describing: targetSettingFeatures)
            ]
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
            featureDescriptions.map { key, value in key }.joined(separator: ", ")
        }
    }
}

extension FitnessMachineFeatures {
    public var featureDescriptions: [String : String] {
        get {
            var featureDescriptions: [String : String] = [:]

            if self.contains(.averageSpeedSupported) {
                featureDescriptions["Average Speed"] = "Supported"
            }
            if self.contains(.cadenceSupported) {
                featureDescriptions["Cadence"] = "Supported"
            }
            if self.contains(.totalDistanceSupported) {
                featureDescriptions["Total Distance"] = "Supported"
            }
            if self.contains(.inclinationSupported) {
                featureDescriptions["Inclination"] = "Supported"
            }
            if self.contains(.elevationGainSupported) {
                featureDescriptions["Elevation Gain"] = "Supported"
            }
            if self.contains(.paceSupported) {
                featureDescriptions["Pace"] = "Supported"
            }
            if self.contains(.stepCountSupported) {
                featureDescriptions["Step Count"] = "Supported"
            }
            if self.contains(.resistanceLevelSupported) {
                featureDescriptions["Resistance Level"] = "Supported"
            }
            if self.contains(.strideCountSupported) {
                featureDescriptions["Stride Count"] = "Supported"
            }
            if self.contains(.expendedEnergySupported) {
                featureDescriptions["Expended Energy"] = "Supported"
            }
            if self.contains(.heartRateMeasurementSupported) {
                featureDescriptions["Heart Rate Measurement"] = "Supported"
            }
            if self.contains(.metabolicEquivalentSupported) {
                featureDescriptions["Metabolic Equivalent"] = "Supported"
            }
            if self.contains(.elapsedTimeSupported) {
                featureDescriptions["Elapsed Time"] = "Supported"
            }
            if self.contains(.remainingTimeSupported) {
                featureDescriptions["Remaining Time"] = "Supported"
            }
            if self.contains(.powerMeasurementSupported) {
                featureDescriptions["Power Measurement"] = "Supported"
            }
            if self.contains(.forceonBeltandPowerOutputSupported) {
                featureDescriptions["Force on Belt and Power Output"] = "Supported"
            }
            if self.contains(.userDataRetentionSupported) {
                featureDescriptions["User Data Retention"] = "Supported"
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
            featureDescriptions.map { key, value in key }.joined(separator: ", ")
        }
    }
}

extension TargetSettingFeatures {
    public var featureDescriptions: [String : String] {
        get {
            var featureDescriptions: [String : String] = [:]

            if self.contains(.speedTargetSettingSupported) {
                featureDescriptions["Speed Target Setting"] = "Supported"
            }
            if self.contains(.inclinationTargetSettingSupported) {
                featureDescriptions["Inclination Target Setting"] = "Supported"
            }
            if self.contains(.resistanceTargetSettingSupported) {
                featureDescriptions["Resistance Target Setting"] = "Supported"
            }
            if self.contains(.powerTargetSettingSupported) {
                featureDescriptions["Power Target Setting"] = "Supported"
            }
            if self.contains(.heartRateTargetSettingSupported) {
                featureDescriptions["Heart Rate Target Setting"] = "Supported"
            }
            if self.contains(.targetedExpendedEnergyConfigurationSupported) {
                featureDescriptions["Targeted Expended Energy Configuration"] = "Supported"
            }
            if self.contains(.targetedStepNumberConfigurationSupported) {
                featureDescriptions["Targeted Step Number Configuration"] = "Supported"
            }
            if self.contains(.targetedStrideNumberConfigurationSupported) {
                featureDescriptions["Targeted Stride Number Configuration"] = "Supported"
            }
            if self.contains(.targetedDistanceConfigurationSupported) {
                featureDescriptions["Targeted Distance Configuration"] = "Supported"
            }
            if self.contains(.targetedTrainingTimeConfigurationSupported) {
                featureDescriptions["Targeted Training Time Configuration"] = "Supported"
            }
            if self.contains(.targetedTimeinTwoHeartRateZonesConfigurationSupported) {
                featureDescriptions["Targeted Time in Two Heart Rate Zones Configuration"] = "Supported"
            }
            if self.contains(.targetedTimeinThreeHeartRateZonesConfigurationSupported) {
                featureDescriptions["Targeted Time in Three Heart Rate Zones Configuration"] = "Supported"
            }
            if self.contains(.targetedTimeinFiveHeartRateZonesConfigurationSupported) {
                featureDescriptions["Targeted Time in Five Heart Rate Zones Configuration"] = "Supported"
            }
            if self.contains(.indoorBikeSimulationParametersSupported) {
                featureDescriptions["Indoor Bike Simulation Parameters"] = "Supported"
            }
            if self.contains(.wheelCircumferenceConfigurationSupported) {
                featureDescriptions["Wheel Circumference Configuration"] = "Supported"
            }
            if self.contains(.spinDownControlSupported) {
                featureDescriptions["Spin Down Control"] = "Supported"
            }
            if self.contains(.targetedCadenceConfigurationSupported) {
                featureDescriptions["Targeted Cadence Configuration"] = "Supported"
            }

            return featureDescriptions
        }
    }
}
