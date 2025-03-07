import Foundation

public extension ProcessInfo {
    /// Detects if running in Xcode SwiftUI Preview mode
    static var isXcodePreview: Bool { processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" }
    
    /// Detects if UI Tests are running
    static var isUITesting: Bool { processInfo.arguments.contains("UI_TESTING") }
    
    /// Detects if Unit Tests are running
    static var isUnitTesting: Bool { NSClassFromString("XCTestCase") != nil }
    
    /// Detects if Low Power Mode is enabled
    static var isLowPowerModeActive: Bool { processInfo.isLowPowerModeEnabled }
    
    /// Returns the current system uptime in seconds
    static var currentSystemUptime: Double { processInfo.systemUptime }
    
    /// Returns the system uptime in days (rounded to 2 decimals)
    static var systemUptimeInDays: Double {
        let days = currentSystemUptime / 86400 // 1 day = 86,400 seconds
        return round(days * 100) / 100
    }
    
    /// Detects if running on Mac Catalyst
    static var isRunningOnMacCatalyst: Bool { processInfo.isMacCatalystApp }
    
    /// Detects if running an iOS app on Mac
    static var isRunningiOSAppOnMac: Bool { processInfo.isiOSAppOnMac }
}
