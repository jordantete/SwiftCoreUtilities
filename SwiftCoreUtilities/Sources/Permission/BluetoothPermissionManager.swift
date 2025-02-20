import CoreBluetooth

public protocol BluetoothPermissionManager {
    func requestBluetoothPermission(completion: @escaping (PermissionState) -> Void)
    func currentBluetoothPermissionState() -> PermissionState
}

public final class BluetoothPermissionManagerImpl: NSObject, BluetoothPermissionManager {
    // MARK: - Private Properties
    
    private let centralManager: CBCentralManager
    private var permissionCompletion: ((PermissionState) -> Void)?
    
    // MARK: - Initialization
    
    public override init() {
        self.centralManager = CBCentralManager(delegate: nil, queue: nil)
        super.init()
        self.centralManager.delegate = self
    }

    // MARK: - BluetoothPermissionManager
    
    public func requestBluetoothPermission(completion: @escaping (PermissionState) -> Void) {
        permissionCompletion = completion
        let currentState = currentBluetoothPermissionState()
        completion(currentState)
    }
    
    public func currentBluetoothPermissionState() -> PermissionState {
        return mapBluetoothAuthorizationStatus(CBCentralManager.authorization)
    }
    
    // MARK: - Private methods

    private func mapBluetoothAuthorizationStatus(_ status: CBManagerAuthorization) -> PermissionState {
        switch status {
        case .notDetermined:        return .notDetermined
        case .restricted:           return .restricted
        case .denied:               return .denied
        case .allowedAlways:        return .granted
        @unknown default:           return .notDetermined
        }
    }
}

// MARK: - CBCentralManagerDelegate
extension BluetoothPermissionManagerImpl: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        let permissionState = mapBluetoothAuthorizationStatus(CBCentralManager.authorization)
        permissionCompletion?(permissionState)
        permissionCompletion = nil
    }
}
