import XCTest
import CoreMotion
@testable import SwiftCoreUtilities

final class MockCMMotionManager: CMMotionManager {
    var mockAcceleration: CMAcceleration?
    var isAccelerometerRunning = false
    
    override var isAccelerometerAvailable: Bool {
        return true
    }
    
    override func startAccelerometerUpdates(to queue: OperationQueue, withHandler handler: @escaping CMAccelerometerHandler) {
        isAccelerometerRunning = true
        if let mockAcceleration = mockAcceleration {
            handler(CMAccelerometerDataMock(acceleration: mockAcceleration), nil)
        }
    }
    
    override func stopAccelerometerUpdates() {
        isAccelerometerRunning = false
    }
}

final class CMAccelerometerDataMock: CMAccelerometerData {
    private let _acceleration: CMAcceleration

    init(acceleration: CMAcceleration) {
        self._acceleration = acceleration
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var acceleration: CMAcceleration {
        return _acceleration
    }
}
