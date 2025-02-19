import CoreLocation

protocol LocationPermissionManager {
    func requestLocationPermission(completion: @escaping (PermissionState) -> Void)
    func requestBackgroundLocationPermission(completion: @escaping (PermissionState) -> Void)
    func currentLocationPermissionState(for type: PermissionType) -> PermissionState
}

final class LocationPermissionManagerImpl: NSObject, LocationPermissionManager, CLLocationManagerDelegate {
    // MARK: - Private properties
    
    private let locationManager: CLLocationManager
    private var previousPermissionStatus: CLAuthorizationStatus?
    private var permissionCompletion: ((PermissionState) -> Void)?
    
    // MARK: - Initialization
    
    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        self.previousPermissionStatus = locationManager.authorizationStatus
        
        super.init()
        self.locationManager.delegate = self
    }
    
    // MARK: - LocationPermissionManager
    
    func requestLocationPermission(completion: @escaping (PermissionState) -> Void) {
        permissionCompletion = completion
        let status = locationManager.authorizationStatus
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        if status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
            return
        }
        
        completion(mapCLAuthorizationStatus(status))
    }
    
    func requestBackgroundLocationPermission(completion: @escaping (PermissionState) -> Void) {
        permissionCompletion = completion
        let status = locationManager.authorizationStatus
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        if status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
            return
        }
        
        completion(mapCLAuthorizationStatus(status))
    }
    
    func currentLocationPermissionState(for type: PermissionType) -> PermissionState {
        switch type {
        case .location, .backgroundLocation:
            return mapCLAuthorizationStatus(locationManager.authorizationStatus)
        @unknown default:
            LogManager.error("Unsupported PermissionType: \(type) in this context")
            return .denied
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status != previousPermissionStatus else { return }
        previousPermissionStatus = status
        
        let permissionState = mapCLAuthorizationStatus(status)
        permissionCompletion?(permissionState)
        permissionCompletion = nil
    }
    
    // MARK: - Private methods
    
    private func mapCLAuthorizationStatus(_ status: CLAuthorizationStatus) -> PermissionState {
        switch status {
        case .notDetermined:            return .notDetermined
        case .restricted:               return .restricted
        case .denied:                   return .denied
        case .authorizedWhenInUse:      return .authorizedWhenInUse
        case .authorizedAlways:         return .authorizedAlways
        @unknown default:               return .notDetermined
        }
    }
}
