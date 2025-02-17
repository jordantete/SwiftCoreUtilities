import CoreMotion

protocol MotionManager {
    func startAccelerometerUpdates()
    func stopAccelerometerUpdates()
    func getLatestAcceleration() -> CMAcceleration
}

final class MotionManagerImpl: MotionManager {
    // MARK: - Private properties

    private let motionManager: CMMotionManager
    private let queue: OperationQueue
    private var latestAcceleration: CMAcceleration?
    
    // MARK: - Initialization

    init() {
        self.motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 0.5 // Adjust as needed
        self.queue = OperationQueue()
        self.queue.name = "com.motion.queue"
    }
    
    // MARK: - Public methods

    func startAccelerometerUpdates() {
        guard motionManager.isAccelerometerAvailable else {
            LogManager.warning("Accelerometer is not available on this device")
            return
        }
        
        motionManager.startAccelerometerUpdates(to: queue) { [weak self] data, error in
            guard let self = self, let acceleration = data?.acceleration else {
                LogManager.error("Accelerometer error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.latestAcceleration = acceleration
        }
    }
    
    func stopAccelerometerUpdates() {
        motionManager.stopAccelerometerUpdates()
        latestAcceleration = nil
        LogManager.info("Stopped accelerometer updates")
    }

    func getLatestAcceleration() -> CMAcceleration {
        latestAcceleration ?? CMAcceleration(x: 0.0, y: 0.0, z: 0.0)
    }
}
