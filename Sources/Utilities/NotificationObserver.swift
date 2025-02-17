import Foundation

protocol Observer: AnyObject {
    func update(event: NotificationEvent)
}

enum NotificationEvent {
    case permissionsChanged(permissionType: String, state: String)
    case syncStateChanged(state: String)
}

protocol NotificationObserver {
    func addObserver(_ observer: Observer)
    func removeObserver(_ observer: Observer)
    func post(event: NotificationEvent)
}

final class NotificationObserverImpl: NotificationObserver {
    // MARK: - Private methods
    
    private var observers = NSHashTable<AnyObject>.weakObjects()
    private let queue = DispatchQueue(label: "com.notification.manager", attributes: .concurrent)
    
    // MARK: - NotificationObserver
    
    func addObserver(_ observer: Observer) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            if !self.observers.contains(observer) {
                self.observers.add(observer)
            }
        }
    }
    
    func removeObserver(_ observer: Observer) {
        queue.async(flags: .barrier) { [weak self] in
            self?.observers.remove(observer)
        }
    }
    
    func post(event: NotificationEvent) {
        queue.sync { [weak self] in
            guard let self = self else { return }
            let validObservers = self.observers.allObjects.compactMap { $0 as? Observer }
            LogManager.info("Dispatching event: \(event) to \(validObservers.count) observers")

            for observer in validObservers {
                observer.update(event: event)
            }
        }
    }
}
