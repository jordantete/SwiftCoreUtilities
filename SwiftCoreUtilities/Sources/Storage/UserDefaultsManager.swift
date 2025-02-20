import Foundation

public protocol UserDefaultsManager {
    func isFeatureEnabled() -> Bool
    func setFeatureEnabled(_ enabled: Bool)
}

public final class UserDefaultsManagerImpl: UserDefaultsManager {
    // MARK: - Private properties
    
    private let defaults: UserDefaults
    
    private enum Keys {
        static let isFeatureEnabled = "isFeatureEnabled"
    }
    
    // MARK: - Initialization
    
    init(userDefaults: UserDefaults = .standard) {
        self.defaults = userDefaults
    }
    
    // MARK: - UserDefaultsManager
    
    public func isFeatureEnabled() -> Bool {
        defaults.bool(forKey: Keys.isFeatureEnabled)
    }
    
    public func setFeatureEnabled(_ enabled: Bool) {
        defaults.set(enabled, forKey: Keys.isFeatureEnabled)
    }
}
