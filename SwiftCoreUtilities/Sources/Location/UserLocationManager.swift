import Foundation
import CoreLocation

public protocol UserLocationManager {
    var delegate: UserLocationManagerDelegate? { get set }
    func startTracking()
    func stopTracking()
    func getCurrentHeading() -> CLHeading?
    func adjustTrackingForLowPowerMode(isEnabled: Bool)
    var distanceFilter: CLLocationDistance { get set }
    var desiredAccuracy: CLLocationAccuracy { get set }
    var activityType: CLActivityType { get set }
}

public protocol UserLocationManagerDelegate: AnyObject {
    func didUpdateLocation(_ location: CLLocation)
    func didFailWithError(_ error: Error)
    func didUpdateHeading(_ heading: CLHeading)
}

public final class UserLocationManagerImpl: NSObject, UserLocationManager {
    // MARK: - Properties
    
    private let locationManager: CLLocationManager
    public weak var delegate: UserLocationManagerDelegate?
    private var lastHeading: CLHeading?
    
    public var distanceFilter: CLLocationDistance {
        didSet { locationManager.distanceFilter = distanceFilter }
    }
    
    public var desiredAccuracy: CLLocationAccuracy {
        didSet { locationManager.desiredAccuracy = desiredAccuracy }
    }
    
    public var activityType: CLActivityType {
        didSet { locationManager.activityType = activityType }
    }
    
    // MARK: - Initialization
    
    init(
        distanceFilter: CLLocationDistance = 50,
        desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyBest,
        activityType: CLActivityType = .other
    ) {
        self.locationManager = CLLocationManager()
        self.distanceFilter = distanceFilter
        self.desiredAccuracy = desiredAccuracy
        self.activityType = activityType

        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = distanceFilter
        locationManager.desiredAccuracy = desiredAccuracy
        locationManager.activityType = activityType
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        
        self.locationManager.headingFilter = 20  // Adjust as needed: Minimum degrees change before update
        self.locationManager.headingOrientation = .portrait
    }
    
    // MARK: - Location Tracking
    
    public func startTracking() {
        LogManager.info("Started tracking user location")
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        if CLLocationManager.headingAvailable() {
            locationManager.startUpdatingHeading()
            LogManager.info("Heading tracking enabled")
        } else {
            LogManager.warning("Device does not support heading tracking")
        }
    }
    
    public func stopTracking() {
        LogManager.info("Stopped tracking user location")
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
        
        if CLLocationManager.headingAvailable() {
            locationManager.stopUpdatingHeading()
            LogManager.info("Stopped heading tracking")
        }
    }
    
    public func getCurrentHeading() -> CLHeading? {
        lastHeading
    }
    
    public func adjustTrackingForLowPowerMode(isEnabled: Bool) {
        if isEnabled {
            LogManager.warning("Low Power Mode enabled – Reducing GPS accuracy.")
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.distanceFilter = 100
        } else {
            LogManager.info("Low Power Mode disabled – Restoring GPS accuracy.")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 50
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension UserLocationManagerImpl: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        
        DispatchQueue.main.async { [weak self] in
            LogManager.info("New location update: \(newLocation)")
            self?.delegate?.didUpdateLocation(newLocation)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        guard newHeading.headingAccuracy > 0 else {
            LogManager.warning("Heading accuracy too low, ignoring update.")
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            LogManager.info("Heading updated: \(newHeading.trueHeading)°")
            self?.lastHeading = newHeading
        }
    }
    
    public func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        true
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        LogManager.error("Location tracking error: \(error.localizedDescription)")
        DispatchQueue.main.async { [weak self] in
            LogManager.error("Location tracking error: \(error.localizedDescription)")
            self?.delegate?.didFailWithError(error)
        }
    }
}
