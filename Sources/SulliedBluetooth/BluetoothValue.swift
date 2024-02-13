import Foundation

public enum BluetoothValue {
    case batteryLevel(UInt8)
    case cyclingPower(CyclingPowerMeasurement)
    case systemID(SystemID)
    case modelNumber(String)
    case serialNumberString(String)
    case firmwareRevisionString(String)
    case hardwareRevisionString(String)
    case softwareRevisionString(String)
    case manufacturerNameString(String)
    case cyclingSpeedAndCadence(CSCMeasurement)
    case sensorLocation(SensorLocation)
    case heartRateMeasurement(HeartRateMeasurement)
    case bodySensorLocation(BodySensorLocation)
    case cyclingPowerFeature(CyclingPowerFeature)
    case databaseChangeIncrement(UInt32)
    case userIndex(UserIndex)
    case fitnessMachineFeature(FitnessMachineFeature)
    case supportedResistanceLevelRange(SupportedResistanceLevelRange)
    case supportedPowerRange(SupportedPowerRange)
    case raw(Data)
    case none

    public var fieldDescriptions: [String : String] {
        get {
            switch self {
            case .batteryLevel(let level):
                return ["Battery Level" : "\(level)%"]
            case .cyclingPower(let measurement):
                return measurement.fieldDescriptions
            case .systemID(let id):
                return id.fieldDescriptions
            case .modelNumber(let modelNumber):
                return ["Model Number" : modelNumber]
            case .serialNumberString(let serialNumber):
                return ["Serial Number" : serialNumber]
            case .firmwareRevisionString(let firmwareRevision):
                return ["Firmware Revision" : firmwareRevision]
            case .hardwareRevisionString(let hardwareRevision):
                return ["Hardware Revision" : hardwareRevision]
            case .softwareRevisionString(let softwareRevision):
                return ["Software Revision" : softwareRevision]
            case .manufacturerNameString(let manufacturerName):
                return ["Manufacturer Name" : manufacturerName]
            case .cyclingSpeedAndCadence(let speed):
                return speed.fieldDescriptions
            case .sensorLocation(let location):
                return ["Sensor Location" : String(describing: location)]
            case .heartRateMeasurement(let measurement):
                return measurement.fieldDescriptions
            case .bodySensorLocation(let location):
                return ["Body Sensor Location" : String(describing: location)]
            case .cyclingPowerFeature(let features):
                return features.fieldDescriptions
            case .databaseChangeIncrement(let increment):
                return ["Database Change Increment" : "\(increment)"]
            case .userIndex(let index):
                return ["User Index" : String(describing: index)]
            case .fitnessMachineFeature(let features):
                return features.fieldDescriptions
            case .supportedResistanceLevelRange(let range):
                return range.fieldDescriptions
            case .supportedPowerRange(let range):
                return range.fieldDescriptions
            case .raw(let data):
                return ["Unrecognized" : "\(data)"]
            case .none:
                return [:]
            }
        }
    }
}
