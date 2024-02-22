import Foundation

public enum BluetoothValue {
    case batteryLevel(UInt8)
    case co2Concentration(CO2Concentration)
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
    case apparentWindDirection(ApparentWindDirection)
    case apparentWindSpeed(ApparentWindSpeed)
    case barometricPressureTrend(BarometricPressureTrend)
    case dewPoint(DewPoint)
    case gustFactor(GustFactor)
    case heatIndex(HeatIndex)
    case humidity(Humidity)
    case irradiance(Irradiance)
    case magneticDeclination(MagneticDeclination)
    case magneticFluxDensity2D(MagneticFluxDensity2D)
    case temperature(Temperature)
    case unsupported(UnsupportedMeasurement)
    case raw(Data)
    case none

    public var fieldDescriptions: [String : String] {
        get {
            switch self {
            case .batteryLevel(let level):
                return ["Battery Level" : "\(level)%"]
            case .co2Concentration(let co2):
                return co2.fieldDescriptions
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
                return ["Database Change Increment" : increment != 0 ? "\(increment)" : "New device"]
            case .userIndex(let index):
                return index.fieldDescriptions
            case .fitnessMachineFeature(let features):
                return features.fieldDescriptions
            case .supportedResistanceLevelRange(let range):
                return range.fieldDescriptions
            case .supportedPowerRange(let range):
                return range.fieldDescriptions
            case .apparentWindDirection(let direction):
                return direction.fieldDescriptions
            case .apparentWindSpeed(let speed):
                return speed.fieldDescriptions
            case .barometricPressureTrend(let trend):
                return trend.fieldDescriptions
            case .dewPoint(let temperature):
                return temperature.fieldDescriptions
            case .gustFactor(let factor):
                return factor.fieldDescriptions
            case .heatIndex(let temperature):
                return temperature.fieldDescriptions
            case .humidity(let humidity):
                return humidity.fieldDescriptions
            case .irradiance(let irradiance):
                return irradiance.fieldDescriptions
            case .magneticDeclination(let angle):
                return angle.fieldDescriptions
            case .magneticFluxDensity2D(let flux):
                return flux.fieldDescriptions
            case .temperature(let t):
                return t.fieldDescriptions
            case .raw(let data):
                return ["Unrecognized" : "\(data)"]
            case .unsupported(let unsupported):
                return unsupported.fieldDescriptions
            case .none:
                return [:]
            }
        }
    }
}
