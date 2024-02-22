import Foundation

extension BluetoothValue : CustomStringConvertible {
    public var description: String {
        get {
            switch self {
            case .batteryLevel(let level):
                return "\(level)%"
            case .co2Concentration(let co2):
                return String(describing: co2)
            case .cyclingPower(let measurement):
                return String(describing: measurement)
            case .systemID(let id):
                return String(describing: id)
            case .modelNumber(let modelNumber):
                return modelNumber
            case .serialNumberString(let serialNumber):
                return serialNumber
            case .firmwareRevisionString(let firmwareRevision):
                return firmwareRevision
            case .hardwareRevisionString(let hardwareRevision):
                return hardwareRevision
            case .softwareRevisionString(let softwareRevision):
                return softwareRevision
            case .manufacturerNameString(let manufacturerName):
                return manufacturerName
            case .cyclingSpeedAndCadence(let speed):
                return "\(speed)"
            case .sensorLocation(let location):
                return String(describing: location)
            case .heartRateMeasurement(let measurement):
                return "\(measurement)"
            case .bodySensorLocation(let location):
                return String(describing: location)
            case .cyclingPowerFeature(let features):
                return String(describing: features)
            case .databaseChangeIncrement(let increment):
                return "\(increment)"
            case .userIndex(let index):
                return String(describing: index)
            case .fitnessMachineFeature(let features):
                return String(describing: features)
            case .supportedResistanceLevelRange(let range):
                return String(describing: range)
            case .supportedPowerRange(let range):
                return String(describing: range)
            case .apparentWindDirection(let direction):
                return String(describing: direction)
            case .apparentWindSpeed(let speed):
                return String(describing: speed)
            case .barometricPressureTrend(let trend):
                return String(describing: trend)
            case .dewPoint(let temperature):
                return String(describing: temperature)
            case .gustFactor(let factor):
                return String(describing: factor)
            case .heatIndex(let temperature):
                return String(describing: temperature)
            case .humidity(let humidity):
                return String(describing: humidity)
            case .irradiance(let irradiance):
                return String(describing: irradiance)
            case .magneticDeclination(let angle):
                return String(describing: angle)
            case .magneticFluxDensity2D(let flux):
                return String(describing: flux)
            case .magneticFluxDensity3D(let flux):
                return String(describing: flux)
            case .pollenConcentration(let concentration):
                return String(describing: concentration)
            case .pressure(let pressure):
                return String(describing: pressure)
            case .rainfall(let rainfall):
                return String(describing: rainfall)
            case .temperature(let t):
                return String(describing: t)
            case .unsupported(let unsupported):
                return String(describing: unsupported)
            case .raw(let data):
                return "\(data)"
            case .none:
                return "none"
            }
        }
    }
}
