import AVFoundation

protocol CameraPermissionManager {
    func requestCameraPermission(completion: @escaping (PermissionState) -> Void)
    func currentCameraPermissionState() -> PermissionState
}

final class CameraPermissionManagerImpl: CameraPermissionManager {
    func requestCameraPermission(completion: @escaping (PermissionState) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            completion(granted ? .granted : .denied)
        }
    }
    
    func currentCameraPermissionState() -> PermissionState {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:    return .notDetermined
        case .restricted:       return .restricted
        case .denied:           return .denied
        case .authorized:       return .granted
        @unknown default:       return .notDetermined
        }
    }
}
