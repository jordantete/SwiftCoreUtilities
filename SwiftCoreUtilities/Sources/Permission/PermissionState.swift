import Foundation

public enum PermissionState: String {
    case notDetermined
    case restricted
    case denied
    case authorizedWhenInUse
    case authorizedAlways
    case granted
    case provisional
    case ephemeral
}
