import Network

public protocol NetworkMonitorService {
    var isNetworkAvailable: Bool { get }
    func startMonitoring()
    func stopMonitoring()
    var onNetworkAvailable: (() -> Void)? { get set }
}

public final class NetworkMonitorServiceImpl: NetworkMonitorService {
    // MARK: - Private properties
    
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "com.lapile.networkMonitoringService", qos: .background)
    
    // MARK: - Public properties
    
    public var isNetworkAvailable: Bool = false
    public var onNetworkAvailable: (() -> Void)?
    
    // MARK: - Initialization
    
    init(monitor: NWPathMonitor = NWPathMonitor()) {
        self.monitor = monitor
        self.monitor.pathUpdateHandler = { [weak self] path in
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
    
    public func startMonitoring() {
        monitor.start(queue: queue)
        LogManager.info("Start monitoring network")
    }
    
    public func stopMonitoring() {
        monitor.cancel()
        LogManager.info("Stop monitoring network")
    }
}
