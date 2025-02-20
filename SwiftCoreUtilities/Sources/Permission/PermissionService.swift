import Foundation

protocol PermissionService: AnyObject {
    func requestPermission(for type: PermissionType, completion: @escaping (PermissionState) -> Void)
    func permissionState(for type: PermissionType) -> PermissionState
    func startObservingPermissionChanges(for types: [PermissionType])
}

final class PermissionServiceImpl: PermissionService {
    // MARK: - Private properties
    
    private let locationPermissionManager: LocationPermissionManager
    private let notificationPermissionManager: NotificationPermissionManager
    private let cameraPermissionManager: CameraPermissionManager
    private let photoLibraryPermissionManager: PhotoLibraryPermissionManager
    private let bluetoothPermissionManager: BluetoothPermissionManager
    private var observers: [PermissionType: () -> Void] = [:]

    // MARK: - Initialization
    
    init(
        locationPermissionManager: LocationPermissionManager,
        notificationPermissionManager: NotificationPermissionManager,
        cameraPermissionManager: CameraPermissionManager,
        photoLibraryPermissionManager: PhotoLibraryPermissionManager,
        bluetoothPermissionManager: BluetoothPermissionManager
    ) {
        self.locationPermissionManager = locationPermissionManager
        self.notificationPermissionManager = notificationPermissionManager
        self.cameraPermissionManager = cameraPermissionManager
        self.photoLibraryPermissionManager = photoLibraryPermissionManager
        self.bluetoothPermissionManager = bluetoothPermissionManager
        setupObservers()
    }
    
    // MARK: - PermissionService
    
    func requestPermission(for type: PermissionType, completion: @escaping (PermissionState) -> Void) {
        switch type {
        case .location:
            locationPermissionManager.requestLocationPermission(completion: completion)
        case .backgroundLocation:
            locationPermissionManager.requestBackgroundLocationPermission(completion: completion)
        case .notification:
            notificationPermissionManager.requestNotificationPermission(completion: completion)
        case .camera:
            cameraPermissionManager.requestCameraPermission(completion: completion)
        case .photoLibrary:
            photoLibraryPermissionManager.requestPhotoLibraryPermission(completion: completion)
        case .bluetooth:
            bluetoothPermissionManager.requestBluetoothPermission(completion: completion)
        }
    }
    
    func permissionState(for type: PermissionType) -> PermissionState {
        switch type {
        case .location, .backgroundLocation:
            return locationPermissionManager.currentLocationPermissionState(for: type)
        case .notification:
            return notificationPermissionManager.currentNotificationPermission()
        case .camera:
            return cameraPermissionManager.currentCameraPermissionState()
        case .photoLibrary:
            return photoLibraryPermissionManager.currentPhotoLibraryPermissionState()
        case .bluetooth:
            return bluetoothPermissionManager.currentBluetoothPermissionState()
        }
    }
    
    func startObservingPermissionChanges(for types: [PermissionType]) {
        for type in types {
            observers[type]?()
        }
    }
    
    // MARK: - Private Helpers

    private func setupObservers() {
        observers = [
            .notification: { [weak self] in
                self?.notificationPermissionManager.observeNotificationPermissionChanges()
            },
            .location: {
                LogManager.info("Location permission observer not implemented yet.")
            },
            .backgroundLocation: {
                LogManager.info("Background Location permission observer not implemented yet.")
            },
            .camera: {
                LogManager.info("Camera permission observer not implemented yet.")
            },
            .photoLibrary: {
                LogManager.info("Photo Library permission observer not implemented yet.")
            },
            .bluetooth: {
                LogManager.info("Bluetooth permission observer not implemented yet.")
            }
        ]
    }
}
