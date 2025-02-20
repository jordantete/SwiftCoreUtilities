import MapKit
import CoreLocation

public protocol MapKitService {
    func geocodeAddress(_ address: String, completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void)
    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D, completion: @escaping (Result<String, Error>) -> Void)
    func openInAppleMaps(latitude: Double, longitude: Double, name: String?)
    func calculateDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double
}

public final class MapKitServiceImpl: NSObject, MapKitService {
    // MARK: - Private properties

    private let geocoder = CLGeocoder()
    
    // MARK: - MapKitService
    
    public func geocodeAddress(_ address: String, completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let coordinate = placemarks?.first?.location?.coordinate {
                completion(.success(coordinate))
            } else {
                let error = NSError(domain: "MapKitService", code: 404, userInfo: [NSLocalizedDescriptionKey: "No location found"])
                completion(.failure(error))
            }
        }
    }
    
    public func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D, completion: @escaping (Result<String, Error>) -> Void) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let address = placemarks?.first?.name {
                completion(.success(address))
            } else {
                completion(.failure(NSError(domain: "MapKitService", code: 404, userInfo: [NSLocalizedDescriptionKey: "No address found"])))
            }
        }
    }
    
    public func openInAppleMaps(latitude: Double, longitude: Double, name: String? = nil) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = name
        mapItem.openInMaps()
    }
    
    public func calculateDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let location1 = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let location2 = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return location1.distance(from: location2) // Distance in meters
    }
}
