import Network

protocol NetworkMonitorService {
    var isNetworkAvailable: Bool { get }
    func startMonitoring()
    func stopMonitoring()
    var onNetworkAvailable: (() -> Void)? { get set }
}

final class NetworkMonitorServiceImpl: NetworkMonitorService {
    // MARK: - Private properties
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "com.lapile.networkMonitoringService", qos: .background)
    
    // MARK: - Public properties
    
    var isNetworkAvailable: Bool = false
    var onNetworkAvailable: (() -> Void)?
    
    // MARK: - Initialization
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            let wasOffline = !(self?.isNetworkAvailable ?? false)
            self?.isNetworkAvailable = path.status == .satisfied
            
            if wasOffline && self?.isNetworkAvailable == true {
                DispatchQueue.main.async {
                    LogManager.info("Network became available")
                    self?.onNetworkAvailable?()
                }
            }
        }
    }
    
    // MARK: - Public methods
    
    func startMonitoring() {
        monitor.start(queue: queue)
        LogManager.info("Start monitoring network")
    }
    
    func stopMonitoring() {
        monitor.cancel()
        LogManager.info("Stop monitoring network")
    }
}
