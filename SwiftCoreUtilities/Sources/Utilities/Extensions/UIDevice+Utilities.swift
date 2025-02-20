import UIKit

public extension UIDevice {
    /// The device name (e.g., "John’s iPhone")
    static var deviceName: String { current.name }
    
    /// The system name (e.g., "iOS")
    static var deviceSystemName: String { current.systemName }
    
    /// The system version (e.g., "17.0")
    static var deviceSystemVersion: String { current.systemVersion }
    
    /// The model name (e.g., "iPhone", "iPad")
    static var deviceModel: String { current.model }
    
    /// The unique vendor identifier (IDFV)
    static var deviceIdentifierForVendor: String { current.identifierForVendor?.uuidString ?? "No ID" }
    
    /// Detect if the device is an iPad
    static var isiPad: Bool { current.userInterfaceIdiom == .pad }
    
    /// Detect if the device is an iPhone
    static var isiPhone: Bool { current.userInterfaceIdiom == .phone }
    
    /// The current battery level (0.0 to 1.0)
    static var deviceBatteryLevel: Float { current.batteryLevel }
    
    /// The current battery state (charging, full, unplugged)
    static var deviceBatteryState: UIDevice.BatteryState { current.batteryState }
    
    /// The device’s orientation (portrait, landscape, etc.)
    static var deviceOrientation: UIDeviceOrientation { current.orientation }
    
    /// Detect if the device is in portrait mode
    static var isPortraitMode: Bool { current.orientation.isPortrait }
    
    /// Detect if the device is in landscape mode
    static var isLandscapeMode: Bool { current.orientation.isLandscape }
}
