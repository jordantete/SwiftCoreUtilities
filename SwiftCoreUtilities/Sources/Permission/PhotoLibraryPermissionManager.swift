import Photos

public protocol PhotoLibraryPermissionManager {
    func requestPhotoLibraryPermission(completion: @escaping (PermissionState) -> Void)
    func currentPhotoLibraryPermissionState() -> PermissionState
}

public final class PhotoLibraryPermissionManagerImpl: PhotoLibraryPermissionManager {
    // MARK: - Initialization

    public init() {}

    // MARK: - PhotoLibraryPermissionManager
    
    public func requestPhotoLibraryPermission(completion: @escaping (PermissionState) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            completion(self.mapPhotoLibraryPermission(status: status))
        }
    }
    
    public func currentPhotoLibraryPermissionState() -> PermissionState {
        mapPhotoLibraryPermission(status: PHPhotoLibrary.authorizationStatus())
    }
    
    // MARK: - Private methods
    
    private func mapPhotoLibraryPermission(status: PHAuthorizationStatus) -> PermissionState {
        switch status {
        case .notDetermined:            return .notDetermined
        case .restricted:               return .restricted
        case .denied:                   return .denied
        case .authorized, .limited:     return .granted
        @unknown default:               return .notDetermined
        }
    }
}
