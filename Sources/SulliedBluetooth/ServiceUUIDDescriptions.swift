import Foundation
import CoreBluetooth

let ServiceUUIDDescriptions: [CBUUID : String] = [
    CBUUID(string: "0x1800") : "Generic Access",
    CBUUID(string: "0x1801") : "Generic Attribute",
    CBUUID(string: "0x1802") : "Immediate Alert",
    CBUUID(string: "0x1803") : "Link Loss",
    CBUUID(string: "0x1804") : "Tx Power",
    CBUUID(string: "0x1805") : "Current Time",
    CBUUID(string: "0x1806") : "Reference Time Update",
    CBUUID(string: "0x1807") : "Next DST Change",
    CBUUID(string: "0x1808") : "Glucose",
    CBUUID(string: "0x1809") : "Health Thermometer",
    CBUUID(string: "0x180A") : "Device Information",
    CBUUID(string: "0x180D") : "Heart Rate",
    CBUUID(string: "0x180E") : "Phone Alert Status",
    CBUUID(string: "0x180F") : "Battery",
    CBUUID(string: "0x1810") : "Blood Pressure",
    CBUUID(string: "0x1811") : "Alert Notification",
    CBUUID(string: "0x1812") : "Human Interface Device",
    CBUUID(string: "0x1813") : "Scan Parameters",
    CBUUID(string: "0x1814") : "Running Speed and Cadence",
    CBUUID(string: "0x1815") : "Automation IO",
    CBUUID(string: "0x1816") : "Cycling Speed and Cadence",
    CBUUID(string: "0x1818") : "Cycling Power",
    CBUUID(string: "0x1819") : "Location and Navigation",
    CBUUID(string: "0x181A") : "Environmental Sensing",
    CBUUID(string: "0x181B") : "Body Composition",
    CBUUID(string: "0x181C") : "User Data",
    CBUUID(string: "0x181D") : "Weight Scale",
    CBUUID(string: "0x181E") : "Bond Management",
    CBUUID(string: "0x181F") : "Continuous Glucose Monitoring",
    CBUUID(string: "0x1820") : "Internet Protocol Support",
    CBUUID(string: "0x1821") : "Indoor Positioning",
    CBUUID(string: "0x1822") : "Pulse Oximeter",
    CBUUID(string: "0x1823") : "HTTP Proxy",
    CBUUID(string: "0x1824") : "Transport Discovery",
    CBUUID(string: "0x1825") : "Object Transfer",
    CBUUID(string: "0x1826") : "Fitness Machine",
    CBUUID(string: "0x1827") : "Mesh Provisioning",
    CBUUID(string: "0x1828") : "Mesh Proxy",
    CBUUID(string: "0x1829") : "Reconnection Configuration",
    CBUUID(string: "0x183A") : "Insulin Delivery",
    CBUUID(string: "0x183B") : "Binary Sensor",
    CBUUID(string: "0x183C") : "Emergency Configuration",
    CBUUID(string: "0x183D") : "Authorization Control",
    CBUUID(string: "0x183E") : "Physical Activity Monitor",
    CBUUID(string: "0x183F") : "Elapsed Time",
    CBUUID(string: "0x1840") : "Generic Health Sensor",
    CBUUID(string: "0x1843") : "Audio Input Control",
    CBUUID(string: "0x1844") : "Volume Control",
    CBUUID(string: "0x1845") : "Volume Offset Control",
    CBUUID(string: "0x1846") : "Coordinated Set Identification",
    CBUUID(string: "0x1847") : "Device Time",
    CBUUID(string: "0x1848") : "Media Control",
    CBUUID(string: "0x1849") : "Generic Media Control",
    CBUUID(string: "0x184A") : "Constant Tone Extension",
    CBUUID(string: "0x184B") : "Telephone Bearer",
    CBUUID(string: "0x184C") : "Generic Telephone Bearer",
    CBUUID(string: "0x184D") : "Microphone Control",
    CBUUID(string: "0x184E") : "Audio Stream Control",
    CBUUID(string: "0x184F") : "Broadcast Audio Scan",
    CBUUID(string: "0x1850") : "Published Audio Capabilities",
    CBUUID(string: "0x1851") : "Basic Audio Announcement",
    CBUUID(string: "0x1852") : "Broadcast Audio Announcement",
    CBUUID(string: "0x1853") : "Common Audio",
    CBUUID(string: "0x1854") : "Hearing Access",
    CBUUID(string: "0x1855") : "Telephony and Media Audio",
    CBUUID(string: "0x1856") : "Public Broadcast Announcement",
    CBUUID(string: "0x1857") : "Electronic Shelf Label",
    CBUUID(string: "0x1858") : "Gaming Audio",
    CBUUID(string: "0x1859") : "Mesh Proxy Solicitation",
    CBUUID(string: "0xFEEE") : "Polar Electro Oy"
]