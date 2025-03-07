import CoreMotion

public enum MotionManagerError: Error, Equatable {
    case accelerometerUnavailable
    case unknown(Error)
    
    public static func == (lhs: MotionManagerError, rhs: MotionManagerError) -> Bool {
        switch (lhs, rhs) {
        case (.accelerometerUnavailable, .accelerometerUnavailable):
            return true
        case let (.unknown(lhsError), .unknown(rhsError)):
            return (lhsError as NSError).domain == (rhsError as NSError).domain &&
                   (lhsError as NSError).code == (rhsError as NSError).code
        default:
            return false
        }
    }
}

public protocol MotionManagerDelegate: AnyObject {
    func didUpdateAcceleration(_ acceleration: CMAcceleration)
    func didFailWithError(_ error: MotionManagerError)
}

public protocol MotionManager {
    var delegate: MotionManagerDelegate? { get set }
    func startAccelerometerUpdates()
    func stopAccelerometerUpdates()
    func getLatestAcceleration() -> CMAcceleration
}

public final class MotionManagerImpl: MotionManager {
    // MARK: - Private properties

    private let motionManager: CMMotionManager
    private let queue: OperationQueue
    private var latestAcceleration: CMAcceleration?
    public weak var delegate: MotionManagerDelegate?
    
    // MARK: - Initialization

    init(accelerometerUpdateInterval: TimeInterval = 0.5, motionManager: CMMotionManager = CMMotionManager()) {
        self.motionManager = motionManager
        self.motionManager.accelerometerUpdateInterval = accelerometerUpdateInterval
        queue = OperationQueue()
        queue.name = "com.motion.queue"
        queue.maxConcurrentOperationCount = 1
    }
    
    // MARK: - Public methods

    public func startAccelerometerUpdates() {
        guard motionManager.isAccelerometerAvailable else {
            LogManager.warning("Accelerometer is not available on this device")
            return
        }
        
        motionManager.startAccelerometerUpdates(to: queue) { [weak self] data, error in
            guard let self = self else { return }
            
            if let error = error {
                LogManager.error("Accelerometer error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.delegate?.didFailWithError(.unknown(error))
                }
                return
            }
            
            guard let acceleration = data?.acceleration else {
                LogManager.error("Failed to retrieve acceleration data")
                DispatchQueue.main.async {
                    self.delegate?.didFailWithError(.accelerometerUnavailable)
                }
                return
            }
            
            self.latestAcceleration = acceleration
            DispatchQueue.main.async {
                self.delegate?.didUpdateAcceleration(acceleration)
            }
        }
    }
    
    public func stopAccelerometerUpdates() {
        motionManager.stopAccelerometerUpdates()
        latestAcceleration = nil
        LogManager.info("Stopped accelerometer updates")
    }
    
    public func getLatestAcceleration() -> CMAcceleration {
        latestAcceleration ?? CMAcceleration(x: 0.0, y: 0.0, z: 0.0)
    }
}
