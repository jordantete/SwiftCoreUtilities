import UIKit

public extension UIDevice {
    /// The device name (e.g., "John’s iPhone")
    static var deviceName: String { current.name }
    
    /// The system name (e.g., "iOS")
    static var systemName: String { UIDevice.systemName }
    
    /// The system version (e.g., "17.0")
    static var systemVersion: String { UIDevice.systemVersion }
    
    /// The model name (e.g., "iPhone", "iPad")
    static var model: String { UIDevice.model }
    
    /// The unique vendor identifier (IDFV)
    static var identifierForVendor: String { UIDevice.identifierForVendor }
    
    /// Detect if the device is an iPad
    static var isiPad: Bool { current.userInterfaceIdiom == .pad }
    
    /// Detect if the device is an iPhone
    static var isiPhone: Bool { current.userInterfaceIdiom == .phone }
    
    /// The current battery level (0.0 to 1.0)
    static var batteryLevel: Float { UIDevice.batteryLevel }
    
    /// The current battery state (charging, full, unplugged)
    static var batteryState: UIDevice.BatteryState { UIDevice.batteryState }
    
    /// The device’s orientation (portrait, landscape, etc.)
    static var orientation: UIDeviceOrientation { UIDevice.orientation }
    
    /// Detect if the device is in portrait mode
    static var isPortrait: Bool { UIDevice.orientation.isPortrait }
    
    /// Detect if the device is in landscape mode
    static var isLandscape: Bool { UIDevice.orientation.isLandscape }    
}
