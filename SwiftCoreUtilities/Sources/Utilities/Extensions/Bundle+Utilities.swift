import Foundation

public extension Bundle {
    /// The app's version number (e.g., "1.0.0")
    static var appVersion: String { main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown" }
    
    /// The app's build number (e.g., "42")
    static var buildNumber: String { main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown" }
    
    /// The app's name
    static var appName: String { main.infoDictionary?["CFBundleName"] as? String ?? "Unknown" }
    
    /// The app's bundle identifier (e.g., "com.organization.MyApp")
    static var bundleIdentifier: String { Bundle.bundleIdentifier ?? "Unknown" }
    
    /// The minimum required iOS version
    static var minimumOSVersion: String { main.infoDictionary?["MinimumOSVersion"] as? String ?? "Unknown" }
}
