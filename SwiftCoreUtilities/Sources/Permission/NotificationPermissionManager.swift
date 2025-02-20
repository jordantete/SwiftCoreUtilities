import UserNotifications
import UIKit

public protocol NotificationPermissionManager {
    func requestNotificationPermission(completion: @escaping (PermissionState) -> Void)
    func currentNotificationPermission() -> PermissionState
    func observeNotificationPermissionChanges()
}

public final class NotificationPermissionManagerImpl: NotificationPermissionManager {
    // MARK: - Private properties
    
    private let userNotificationCenter: UNUserNotificationCenter
    private var previousPermissionStatus: UNAuthorizationStatus?
    
    // MARK: - Initialization
    
    public init(userNotificationCenter: UNUserNotificationCenter = .current()) {
        self.userNotificationCenter = userNotificationCenter
        self.previousPermissionStatus = self.currentNotificationPermission().rawValue == "granted" ? .authorized : .denied
    }
    
    // MARK: - NotificationPermissionManager
    
    public func requestNotificationPermission(completion: @escaping (PermissionState) -> Void) {
        userNotificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in
            self.userNotificationCenter.getNotificationSettings { settings in
                let mappedState = self.mapUNAuthorizationStatus(settings.authorizationStatus)
                completion(mappedState)
            }
        }
    }
    
    public func currentNotificationPermission() -> PermissionState {
        getCurrentPermissionState()
    }
    
    public func observeNotificationPermissionChanges() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(checkNotificationPermissionStatus),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    // MARK: - Private methods
    
    private func getCurrentPermissionState() -> PermissionState {
        var status = UNAuthorizationStatus.notDetermined
        let semaphore = DispatchSemaphore(value: 0)
        userNotificationCenter.getNotificationSettings { settings in
            status = settings.authorizationStatus
            semaphore.signal()
        }
        semaphore.wait()
        return mapUNAuthorizationStatus(status)
    }
    
    @objc private func checkNotificationPermissionStatus() {
        userNotificationCenter.getNotificationSettings { settings in
            let currentStatus = settings.authorizationStatus
            guard currentStatus != self.previousPermissionStatus else { return }
            self.previousPermissionStatus = currentStatus
            LogManager.info("Notification permission changed: \(currentStatus)")
        }
    }
    
    private func mapUNAuthorizationStatus(_ status: UNAuthorizationStatus) -> PermissionState {
        switch status {
        case .notDetermined: return .notDetermined
        case .denied: return .denied
        case .authorized: return .granted
        case .provisional: return .provisional
        case .ephemeral: return .ephemeral
        @unknown default: return .notDetermined
        }
    }
}
