import Foundation

enum ServiceLifetime {
    case singleton
    case transient
}

/// Dependency Injection Container
final class ServiceLocator {
    // MARK: - Private properties
    
    static let shared = ServiceLocator()
    private var services: [ObjectIdentifier: Any] = [:]
    private var factories: [ObjectIdentifier: () -> Any] = [:]
    private let lock = DispatchQueue(label: "com.serviceLocator.lock", attributes: .concurrent)
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Registration Methods
    
    func register<T>(_ service: T, for type: T.Type) {
        let key = ObjectIdentifier(type)
        lock.async(flags: .barrier) {
            self.services[key] = service
        }
    }
    
    func register<T>(_ factory: @escaping () -> T, for type: T.Type, lifetime: ServiceLifetime) {
        let key = ObjectIdentifier(type)
        lock.async(flags: .barrier) {
            switch lifetime {
            case .singleton:
                self.services[key] = factory()
            case .transient:
                self.factories[key] = factory
            }
        }
    }
    
    // MARK: - Resolution Methods
    
    func resolve<T>(_ type: T.Type) -> T {
        let key = ObjectIdentifier(type)
        return lock.sync {
            if let service = services[key] as? T {
                return service
            } else if let factory = factories[key], let instance = factory() as? T {
                return instance
            } else {
                fatalError("Dependency \(type) not registered")
            }
        }
    }
    
    func resolveOptional<T>(_ type: T.Type) -> T? {
        let key = ObjectIdentifier(type)
        return lock.sync {
            if let service = services[key] as? T {
                return service
            } else if let factory = factories[key], let instance = factory() as? T {
                return instance
            } else {
                return nil
            }
        }
    }
}
