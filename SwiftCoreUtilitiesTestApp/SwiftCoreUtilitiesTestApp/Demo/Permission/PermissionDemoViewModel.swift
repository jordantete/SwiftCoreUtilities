import SwiftUI
import SwiftCoreUtilities

final class PermissionDemoViewModel: ObservableObject {
    private let permissionService: PermissionService
    @Published var permissions: [PermissionItem] = []
    
    init() {
        self.permissionService = PermissionServiceImpl(
            locationPermissionManager: LocationPermissionManagerImpl(),
            notificationPermissionManager: NotificationPermissionManagerImpl(),
            cameraPermissionManager: CameraPermissionManagerImpl(),
            photoLibraryPermissionManager: PhotoLibraryPermissionManagerImpl(),
            bluetoothPermissionManager: BluetoothPermissionManagerImpl()
        )
        refreshPermissionStates()
    }
    
    func refreshPermissionStates() {
        let types: [PermissionType] = [.location, .backgroundLocation, .notification, .camera, .photoLibrary, .bluetooth]
        permissions = types.map { PermissionItem(type: $0, state: permissionService.permissionState(for: $0)) }
    }
    
    func requestPermission(for type: PermissionType) {
        permissionService.requestPermission(for: type) { [weak self] newState in
            DispatchQueue.main.async {
                self?.refreshPermissionStates()
            }
        }
    }
}

struct PermissionItem: Identifiable {
    let id = UUID()
    let type: PermissionType
    var state: PermissionState
}
